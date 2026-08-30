<?php
namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use phpDocumentor\Reflection\Types\Self_;
use Illuminate\Support\Facades\Hash;
use App\Models\GarbageCollection;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Client;
use App\Models\User;
use App\Models\Outlet;
use App\Models\Setting;
use App\Models\Appointment;
use Session;
use Auth;
use DB;
use Mail;
use URL;
use Illuminate\Support\Facades\Log;
use commonHelper;

class DashboardApiController extends Controller
{

    public  function __construct()
    {

    }

    public function GetDashboardData(){
        try{

            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $invoiceTotal = 0;
            $mailbox = Auth::user()->mailbox;
            $setting = DB::table('settings')->first();
            $setting->reffral_weight = (int) $setting->reffral_weight;
            $data['setting'] = $setting;
            $data['outstanding_package'] = DB::table('packages')->where('packages.status' , 1)->where('packages.mailbox' , $mailbox)->count();
            $data['in_transit'] = DB::table('packages')->where('packages.status' , 2)->where('packages.mailbox' , $mailbox)->count();
            $data['outstanding_invoice'] = DB::table('invoices')->where('invoices.mailbox_no' , $mailbox)->where('invoices.status' , 0)->count();
            $package_weight = DB::table('transactions')->where('mailbox' , $mailbox)->sum('weight');
            $data['package_weight'] = $package_weight;
            $packages = DB::table('transactions')->where('mailbox' , $mailbox)->first();
            //dd($packages);
            if($packages){
                if($packages->package_ids != null){
                    $package_count = json_decode($packages->package_ids,true);
                    $data['package_count'] = count($package_count);
                }else{
                    if($package_weight > 0){
                        $data['package_count'] = 1;
                    }else{
                        $data['package_count'] = 0;
                    }
                }

            }else{
                if($package_weight > 0){
                    $data['package_count'] = 1;
                }else{
                    $data['package_count'] = 0;
                }

            }
            $invoiceImount = DB::table('invoices')
                                ->join('invoice_packages' , 'invoice_packages.invoice_id' ,'=','invoices.invoice_id')
                                ->select(DB::raw("SUM(invoice_packages.package_price) as pk_price"),DB::raw("SUM(invoice_packages.custom_fee) as cus_fee"),DB::raw("SUM(invoice_packages.service_fee) as ser_fee"),DB::raw("SUM(invoices.discount_price) as discount_price"))
                                ->where('invoices.email_sent' , 1)
                                ->where('invoices.invoice_type' , 1)
                                ->where('invoices.status' , 0)
                                ->where('invoice_packages.status' , 0)
                                ->where('invoices.mailbox_no' , $mailbox)
                                ->first();
                                //dd($invoiceImount);
            $invoiceImountGct = DB::table('invoices')
                        ->join('invoice_packages' , 'invoice_packages.invoice_id' ,'=','invoices.invoice_id')
                        ->select(DB::raw("SUM(invoice_packages.service_fee) as ser_fee"))
                        ->where('invoices.email_sent' , 1)
                        ->where('invoices.invoice_type' , 1)
                        ->where('invoices.status' , 0)
                        ->where('invoice_packages.status' , 0)
                        ->where('invoices.mailbox_no' , $mailbox)
                        ->where('invoices.gct' , 1)
                        ->first();
                        //dd($invoiceImountGct);
            $invoiceImountExtraFee = DB::table('invoices')
                                    ->join('service_type' , 'service_type.invoice_id' ,'=','invoices.invoice_id')
                                    ->select(DB::raw("SUM(service_type.service_fee) as extra_fee"))
                                    ->where('invoices.email_sent' , 1)
                                    ->where('invoices.invoice_type' , 1)
                                    ->where('invoices.status' , 0)
                                    ->where('invoices.mailbox_no' , $mailbox)
                                    ->first();
            $total = 0;
            $us_rate = DB::table('settings')->first()->us_rate;
            if($invoiceImountExtraFee) {
                $extraFee = $invoiceImountExtraFee->extra_fee * $us_rate;
            }else{
                $extraFee = 0;
            }
            if($invoiceImount){
                if($invoiceImount->pk_price != ''){
                    if($invoiceImountGct){
                        $ser_fee = $invoiceImountGct->ser_fee * $us_rate;
                        $gctAmount = $ser_fee * 15 / 100;
                    }else{
                        $gctAmount = 0;
                    }
                    $totalInv = ($invoiceImount->pk_price + $invoiceImount->cus_fee + $invoiceImount->ser_fee) * $us_rate;
                    $subTotal = $totalInv - $invoiceImount->discount_price;
                    $total = $total + $subTotal + $extraFee + $gctAmount;
                }
            }
            $storageFeeTotal = DB::getSchemaBuilder()->hasTable('invoice_storage_fees')
                ? DB::table('invoice_storage_fees')
                                ->join('invoices', 'invoice_storage_fees.invoice_id', '=', 'invoices.invoice_id')
                                ->where('invoices.email_sent' , 1)
                                ->where('invoices.invoice_type' , 1)
                                ->where('invoices.status' , 0)
                                ->where('invoices.mailbox_no' , $mailbox)
                                ->where('invoice_storage_fees.active', 1)
                                ->sum('invoice_storage_fees.fee_amount')
                : 0;
            $total = $total + $storageFeeTotal;
            $data['outstanding_balance'] = number_format($total,2).' JMD';
            $data['wherehouse'] = DB::table('packages')->where('packages.status' , 3)->where('packages.mailbox' , $mailbox)->count();

            $credit_points = DB::table('member_points')->where('user_id' , $mailbox)->where('status' , 0)->where('type' , 1)->sum('balance');
            $debit_points = DB::table('member_points')->where('user_id' , $mailbox)->where('status' , 0)->where('type' , 2)->sum('balance');
            $member_points = $credit_points - $debit_points;
            $data['member_points'] = (int) number_format($member_points,2);

            $users = User::where('mailbox' , $mailbox)->first();
            //dd($users);
            if($users){
                //$referral_code = base64_encode($users->referral_code);
                $referral_code = base64_encode($users->referral_code);
                $data['referral_code'] = URL::to('register/'.$referral_code);
            }else{
                $referral_code = '';
                $data['referral_code'] =  $referral_code;
            }

            $credit_ref_points = DB::table('member_referral_points')->where('from_user_id' , $users->user_id)->where('status' , 1)->where('type' , 1)->sum('balance');
            $debit_ref_points = DB::table('member_referral_points')->where('from_user_id' , $users->user_id)->where('status' , 0)->where('type' , 2)->sum('balance');
            $ref_debit_points = DB::table('member_points')->where('user_id' , $mailbox)->where('status' , 0)->where('type' , 3)->sum('balance');

            $data['pending_balance'] = DB::table('member_referral_points')->where('from_user_id' , $users->user_id)->where('status' , 0)->where('type' , 1)->sum('balance');
            $ref_available_balance = $credit_ref_points - $debit_ref_points;
            //return $ref_debit_points;
            $data['available_balance'] = $ref_available_balance - $ref_debit_points;
            //$data['available_balance'] = (int) $ref_available_balance;
            $data['account_manager'] = commonHelper::getmanagerName($users->manager_id);
            $data['manager_phone'] = commonHelper::getmanagerphone($users->manager_id);
            $invoice_ids = DB::table('invoices')->where('mailbox_no' , $mailbox)->where('invoices.status' , 0)->pluck('invoice_id')->toArray();

            //return json_encode($invoice_ids);
            if(count($invoice_ids) > 0){
                $invoice_packages = DB::table('invoice_packages')->whereIn('invoice_id' , $invoice_ids)->pluck('tracking_no')->toArray();
               // dd($invoicesPack);
                $data['package_ids'] = implode(',' , $invoice_packages);
                $data['invoice_ids'] = implode(',' , $invoice_ids);
            }else{
                $data['package_ids'] = '';
                $data['invoice_ids'] = '';
            }
            return ['status' => true, 'message' => 'Dashboard data found.','data' => $data];
        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function GetReadyforPickupPackages(){
        try{
            $packageArr = [];
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $mailbox = Auth::user()->mailbox;
            $offset = request()->offset * 20;
            $dataList = DB::table('packages')
                        ->where('packages.mailbox' , $mailbox)
                        ->skip($offset)->take(20)
                        ->get();
            if(count($dataList) > 0){
                foreach($dataList as $row){
                    if($row->invoice != ''){
                        $row->invoice = url('/public/invoices').'/'.$row->invoice;
                    }
                     $checkInvoice = commonHelper::checkInvoice($row->tracking_no);
                    if($checkInvoice != 0){
                        $row->is_invoice = 1;
                        $row->invoice_no = $checkInvoice;
                    }else{
                        $row->is_invoice = 0;
                        $row->invoice_no = 0;
                    }
                    $packageArr[] = $row;
                }
                return ['status' => true,  'message' => 'User packages data found.','data' => $packageArr];
            }else{
                return ['status' => false,  'message' => 'No data found.' , 'data'=>$packageArr];
            }

        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function GetAddressData(){
        try{
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $mailbox = Auth::user()->mailbox;
            $setting = DB::table('settings')->first();
            $addr2=DB::table('settings')->first();
            $admins = User::where('mailbox', $mailbox)->first();
             if($admins){
                    $mailboxRes = $mailbox;
                    $outlet = Outlet::where('outlet_id',$admins->outlet_id)->first();
                    if($outlet){
                        $short_name = $outlet->short_name;
                    }else{
                        $short_name = '';
                    }
                    $malRes = explode('-',$mailboxRes);
                    $mailbox = $malRes[0].'-'.$malRes[1];
                }
                $mailboxRes = explode('STY-' , $mailbox);
            //$admins->address_line2 = $addr2->package_shipping_address_2.'-'.$mailboxRes[1];
            //$setting->sea_shipping_address_2 = $addr2->sea_shipping_address_2.'-'.$mailboxRes[1];
            $admins->address_line2 = $mailbox;
            $admins->address_line2 = $mailbox;
            $setting->sea_shipping_address_2 = $mailbox;

            $setting->express_shipping_address_2 = $addr2->express_shipping_address_2.'-'.$mailboxRes[1];
            $data['setting'] = $setting;
            $admins->user_name = $admins->user_name . ' ' . $mailbox;
            $data['user_info'] = $admins;
            return ['status' => true, 'message' => 'Dashboard address data found.','data' => $data];
        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function GetReferralUsers(){
        try{
            $packageArr = [];
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $referral_code = Auth::user()->referral_code;
            $c_user_id = Auth::user()->user_id;
            $offset = request()->offset * 20;
            $dataList = User::select('user_id','first_name','mailbox','created_at')->where('ref_by' , $referral_code)->skip($offset)->take(20)->get();
            if(count($dataList) > 0){
                foreach($dataList as $row){
                    $credit_ref_points = DB::table('member_referral_points')->where('from_user_id' , $c_user_id)->where('user_id' , $row->user_id)->where('status' , 1)->where('type' , 1)->sum('balance');
                    $debit_ref_points = DB::table('member_referral_points')->where('from_user_id' , $c_user_id)->where('user_id' , $row->user_id)->where('status' , 0)->where('type' , 2)->sum('balance');

                    $pending_balance = DB::table('member_referral_points')->where('from_user_id' , $c_user_id)->where('user_id', $row->user_id)->where('status' , 0)->where('type' , 1)->sum('balance');
                    $available_balance = $credit_ref_points - $debit_ref_points;
                    $row->pending_balance = $pending_balance;
                    $row->available_balance = $available_balance;
                    $setting = Setting::first();
                    $package_weight = DB::table('transactions_referral')->where('mailbox' , $row->mailbox)->sum('weight');
                    $package_count = DB::table('transactions_referral')->where('mailbox' , $row->mailbox)->count();
                    $row->description = 'You can earn '.$setting->referral_amount.'USD on '.$setting->reffral_packages.' packages shipped or reach '.$setting->reffral_weight.'lb weight for shipped packages, currently you shipped '.$package_count.' packages weight '.$package_weight.'lbs.';
                    $c_user_id = session('site_user_id');
                    if($pending_balance > 0){
                        $row->status =  "Pending";
                    }else{
                        $row->status = "Completed";
                    }
                    $packageArr[] = $row;
                }
                return ['status' => true,  'message' => 'User referral list data found.','data' => $packageArr];
            }else{
                return ['status' => false,  'message' => 'No data found.' , 'data'=>$packageArr];
            }

        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function getNews(){
        try{
            $newsListArr = [];
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $mailbox = Auth::user()->mailbox;
            $offset = request()->offset * 20;
            $dataList = DB::table('news')
                        ->orderby('created_at' , 'DESC')
                        ->skip($offset)->take(20)
                        ->get();
            if(count($dataList) > 0){
                foreach($dataList as $row){
                    if($row->image != ''){
                        $row->image = url('').'/public/users/'.$row->image;
                    }
                    $newsListArr[] = $row;
                }
                return ['status' => true,  'message' => 'News data found.','data' => $newsListArr];
            }else{
                return ['status' => false,  'message' => 'No data found.','data' => $newsListArr];
            }


        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }
}
