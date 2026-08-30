<?php
namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use phpDocumentor\Reflection\Types\Self_;
use Illuminate\Support\Facades\Hash;
use App\Models\GarbageCollection;
use GuzzleHttp\Exception\GuzzleException;
use GuzzleHttp\Client;
use App\Models\Enquiry;
use App\Models\Payment;
use App\Models\Appointment;
use Session;
use Auth;
use DB;
use Mail;
use URL;
use Illuminate\Support\Facades\Log;
use Razorpay\Api\Api;
use commonHelper;

class InvoicesApiController extends Controller
{

    public $order_number;
    public function __construct()
    {
        $this->order_number = date("Ymd") . strtoupper(substr(uniqid(sha1(time())),0,4));

        //$this->middleware('auth')->except('thanks');
    }

    public function GetInvoicesSearch(){
        try{
            //return Auth::user()->mailbox;
            $invoicesArr = [];
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $offset = request()->offset * 20;
            $search = request()->keyword;
            if($search != ''){
                if($search == 'paid' || $search == 'Paid'){
                    $paramsArr['status_paid'] = 1;
                }elseif($search == 'unpaid' || $search == 'Unaid'){
                    $paramsArr['status_unpaid'] = 0;
                }else{
                    $paramsArr['invoice_no'] = $search;
                }
                $invoices = DB::table('invoices')->select('invoice_id','invoice_no','mailbox_no','user_name','status','created_at','updated_at as date_paid')
                                ->where('mailbox_no',Auth::user()->mailbox)
                                ->where(function($q) use ($paramsArr)
                                {
                                    foreach($paramsArr as $key => $value)
                                    {
                                        if($key == 'status_paid'){
                                            $q->orWhere('status', 1);
                                        }elseif($key == 'status_unpaid'){
                                            $q->orWhere('status', 0);
                                        }elseif($key == 'invoice_no'){
                                            $q->orWhere('invoice_no', 'LIKE',"%{$value}%");
                                        }
                                    }
                                })
                                ->skip($offset)
                                ->take(20)
                                ->orderby('created_at','DESC')
                                ->get();
                if(count($invoices) > 0){
                    foreach($invoices as $row){
                        if($row->status == 0){
                            $row->status = 'Unpaid';
                        }else{
                            $row->status = 'Paid';
                        }
                        $row->total_invoice = commonHelper::getInvoiceCount($row->invoice_id);
                        $row->total_paid = commonHelper::getInvoiceCountPaid($row->invoice_id);
                        $invoicesArr[] = $row;
                    }
                    return ['status' => true,  'message' => 'Invoice data found.','data' => $invoicesArr];
                }else{
                    return ['status' => true,  'message' => 'No data found.','data' => $invoicesArr];
                }
            }else{
                $invoices = DB::table('invoices')->select('invoice_id','invoice_no','mailbox_no','user_name','status','created_at','updated_at as date_paid')->where('mailbox_no',Auth::user()->mailbox)->skip($offset)->take(20)->orderby('created_at','DESC')->get();
                if(count($invoices) > 0){
                    foreach($invoices as $row){
                        if($row->status == 0){
                            $row->status = 'Unpaid';
                        }else{
                            $row->status = 'Paid';
                        }
                        $row->total_invoice = commonHelper::getInvoiceCount($row->invoice_id);
                        $row->total_paid = commonHelper::getInvoiceCountPaid($row->invoice_id);
                        $invoicesArr[] = $row;
                    }
                    return ['status' => true,  'message' => 'Invoice data found.','data' => $invoicesArr];
                }else{
                    return ['status' => true,  'message' => 'No data found.','data' => $invoicesArr];
                }
            }
        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }


    public function GetAllInvoices(){
        try{
            //return Auth::user()->mailbox;
            $invoicesArr = [];
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $offset = request()->offset * 20;
            $invoices = DB::table('invoices')->select('invoice_id','invoice_no','mailbox_no','user_name','status','created_at','updated_at as date_paid')->where('mailbox_no',Auth::user()->mailbox)->skip($offset)->take(20)->orderby('created_at','DESC')->get();
            if(count($invoices) > 0){
                foreach($invoices as $row){
                    if($row->status == 0){
                        $row->status = 'Unpaid';
                    }else{
                        $row->status = 'Paid';
                    }
                    $row->total_invoice = commonHelper::getInvoiceCount($row->invoice_id);
                    $row->total_paid = commonHelper::getInvoiceCountPaid($row->invoice_id);
                    $invoicesArr[] = $row;
                }
                return ['status' => true,  'message' => 'Invoice data found.','data' => $invoicesArr];
            }else{
                return ['status' => true,  'message' => 'No data found.','data' => $invoicesArr];
            }


        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function InvoicesDetail(){
        try{
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $invoicesArr = [];
            $setting = DB::table('settings')->first();
            $invoices = DB::table('invoices')->join('users','users.mailbox','=','invoices.mailbox_no')->select('invoices.invoice_id','invoices.invoice_no','invoices.freight_type','invoices.mailbox_no','invoices.user_name','invoices.gct','invoices.discount_price','invoices.updated_at as date_paid','users.email','users.address_1')->where('invoice_no',request()->invoice_no)->first();
            if($invoices){
                $totalAmount = 0;
                $totalServiceFee = 0;
                $total_gct = 0;
                $invoices->company_name = $setting->company_name;
                $invoices->local_address = $setting->local_address;
                $invoices->admin_account = 'BB00001';
                $invoices->phone = $setting->phone;
                $invoices->site_email = $setting->site_email;
                $invoices->gst_persent = 15;
                $invoicesPack = DB::table('invoice_packages')->join('packages', 'invoice_packages.tracking_no', '=', 'packages.tracking_no')->select('invoice_packages.*','packages.manifest_no')->where('invoice_id' , $invoices->invoice_id)->get();
                if(count($invoicesPack) > 0){
                    foreach($invoicesPack as $pack){
                        $pack->package_total = number_format(($pack->package_price + $pack->custom_fee + $pack->service_fee) * $setting->us_rate,2).' ';
                        $totalAmount +=  ($pack->package_price + $pack->custom_fee + $pack->service_fee) * $setting->us_rate;
                        $totalServiceFee += $pack->service_fee * $setting->us_rate;
                        $pack->custom_fee = $pack->custom_fee * $setting->us_rate.' ';
                        $pack->service_fee = $pack->service_fee * $setting->us_rate.' ';
                        $pack->package_price = number_format($pack->package_price * $setting->us_rate,2).' ';
                        $pack->package_description = $pack->package_description .' / '.$pack->package_weight.' lbs';
                        $invoicesArr[] = $pack;
                    }
                    $service_type = DB::table('service_type')->where('invoice_id' , $invoices->invoice_id)->sum('service_fee');
                    $service_type = $service_type * $setting->us_rate;
                    $totalAmount = $totalAmount + $service_type;
                    //return $totalServiceFee;
                    if($invoices->gct == 0){
                        $total_gct = 0;
                        $invoices->gst_persent = '0%';
                        $invoices->gst_total = '0.00';
                    }else{
                        $invoices->gst_persent = '15%';
                        $total_gct = $totalServiceFee * 15 / 100;
                        $invoices->gst_total = number_format($total_gct,2);
                    }
                }
                $storage_fee = $this->getInvoiceStorageFee($invoices->invoice_id);
                $storage_fee_total = $storage_fee ? (float) $storage_fee->fee_amount : 0;
                $g_total = $totalAmount + $total_gct;
                $invoices->sub_total = number_format($g_total,2);
                $invoices->storage_fee = $storage_fee;
                $invoices->storage_fee_total = number_format($storage_fee_total,2);
                $invoices->grand_total = number_format($g_total - $invoices->discount_price + $storage_fee_total,2);
                $invoices->invoice_detail = $invoicesArr;
                $additional_fee = DB::table('service_type')->where('invoice_id' , $invoices->invoice_id)->get();
                $additional_array = [];
                if(count($additional_fee) > 0){
                    foreach($additional_fee as $fee){
                        $fee->service_fee = strval($fee->service_fee * $setting->us_rate).' JMD';
                        $additional_array[] = $fee;
                    }
                    $invoices->additional_fee = $additional_array;
                }else{
                    $invoices->additional_fee = [];
                }

                return ['status' => true,  'message' => 'Invoice detail found.','data' => $invoices];
            }else{
                return ['status' => false, 'message' => 'No enquiry found.','data' => null];
            }

        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function GetUnpaidInvoices(){
        try{
            //return Auth::user()->mailbox;
            $invoicesArr = [];
            $jsonrequest = json_decode(file_get_contents('php://input'), true);
            $invoices = DB::table('invoices')->select('invoice_id','invoice_no','mailbox_no','user_name','status','created_at','updated_at as date_paid')->where('status' , 0)->where('mailbox_no',Auth::user()->mailbox)->orderby('created_at','DESC')->get();
            //dd($invoices);
            if(count($invoices) > 0){
                foreach($invoices as $row){
                    if($row->status == 0){
                        $row->status = 'Unpaid';
                    }else{
                        $row->status = 'Paid';
                    }
                    $row->total_invoice = commonHelper::getInvoiceCount($row->invoice_id);
                    $row->total_paid = commonHelper::getInvoiceCountPaid($row->invoice_id);
                    $invoice_packages = DB::table('invoice_packages')->where('invoice_id',$row->invoice_id)->first();
                    if($invoice_packages){
                        $row->tracking_no = $invoice_packages->tracking_no;
                    }else{
                        $row->tracking_no = '';
                    }

                    $invoicesArr[] = $row;
                }
                return ['status' => true,  'message' => 'Invoice data found.','data' => $invoicesArr];
            }else{
                return ['status' => true,  'message' => 'No data found.','data' => $invoicesArr];
            }


        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }
    }

    public function LascoMassPayInvoice(Request $request){
        try{
            $mailbox = Auth::user()->mailbox;
            $invoice_ids = json_encode($request->invoice_ids,true);
            $package_ids = json_encode($request->package_ids,true);
            $package_total = $this->calculateInvoicePaymentTotal($request->invoice_ids, $request->invoice_total);
            $TransactionId = time();
            $Signature = $this->getSignature($TransactionId,$package_total);
            //dd($package_ids);
            DB::table('lasco_transaction')->insert(['mailbox'=>$mailbox,'device'=>'mobile','invoice_ids'=>$invoice_ids,'transaction_id'=>$TransactionId,'signature'=>$Signature,'amount'=>$package_total,'package_ids' =>$package_ids]);
            $redirect_url = route('lasco_payment',['TransactionId'=>$TransactionId,'Signature'=>$Signature,'Amount'=>$package_total]);
            //return redirect()->route('lasco_payment',['TransactionId'=>$TransactionId,'Signature'=>$Signature,'Amount'=>$package_total]);
            return ['status' => true, 'message' => "redirect url found.",'data' => $redirect_url];
        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }

    }

    public function LascoSinglePayInvoice(Request $request){
        try{
            $mailbox = Auth::user()->mailbox;
            $invoice_ids = json_encode($request->invoice_ids,true);
            $package_total = $this->calculateInvoicePaymentTotal($request->invoice_ids, $request->invoice_total);
            $TransactionId = time();
            $Signature = $this->getSignature($TransactionId,$package_total);
            //dd($package_ids);
            DB::table('lasco_transaction')->insert(['mailbox'=>$mailbox,'type'=>'single','device'=>'mobile','invoice_ids'=>$invoice_ids,'transaction_id'=>$TransactionId,'signature'=>$Signature,'amount'=>$package_total]);
            $redirect_url = route('lasco_payment',['TransactionId'=>$TransactionId,'Signature'=>$Signature,'Amount'=>$package_total]);
            return ['status' => true, 'message' => "redirect url found.",'data' => $redirect_url];
        }catch(\Exception $e){
            return ['status' => false, 'user_access' => 0, 'message' => $e->getMessage()];
        }

    }

    public function getSignature($transaction_id,$package_total){
        $curl = curl_init();

        curl_setopt_array($curl, array(
          CURLOPT_URL => 'https://payment.lascobizja.com/gateway/v1/generatepaysignature?ClientId=2M4bDv0V&TransactionId='.$transaction_id.'&CurrencyCode=JMD&Amount='.$package_total,
          CURLOPT_RETURNTRANSFER => true,
          CURLOPT_ENCODING => '',
          CURLOPT_MAXREDIRS => 10,
          CURLOPT_TIMEOUT => 0,
          CURLOPT_FOLLOWLOCATION => true,
          CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
          CURLOPT_CUSTOMREQUEST => 'POST',
          CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer VrLbe2TEjqlvKDYsiPGJNw95'
          ),
        ));

        $response = curl_exec($curl);

        curl_close($curl);
        $result = json_decode($response,true);
        //dd($result['Success']);
        if($result['Success'] == 'Y'){
            return $result['Signature'];
        }else{
            return 'failer';
        }
    }

    private function getInvoiceStorageFee($invoiceId)
    {
        if(!DB::getSchemaBuilder()->hasTable('invoice_storage_fees')){
            return null;
        }

        return DB::table('invoice_storage_fees')
            ->where('invoice_id', $invoiceId)
            ->where(function($query) {
                $query->where('active', 1)
                    ->orWhere('included_in_payment', 1);
            })
            ->orderBy('updated_at', 'DESC')
            ->first();
    }

    private function calculateInvoicePaymentTotal($invoiceIds, $fallbackTotal)
    {
        $ids = $this->parseInvoiceIds($invoiceIds);
        if (count($ids) === 0) {
            return $fallbackTotal;
        }

        $total = 0;
        foreach ($ids as $invoiceId) {
            $total += (float) commonHelper::getInvoiceCountTotal($invoiceId);
        }

        return number_format($total, 2, '.', '');
    }

    private function parseInvoiceIds($invoiceIds)
    {
        if (is_array($invoiceIds)) {
            return array_values(array_filter($invoiceIds));
        }

        $decoded = json_decode($invoiceIds, true);
        if (is_array($decoded)) {
            return array_values(array_filter($decoded));
        }

        return array_values(array_filter(explode(',', (string) $invoiceIds)));
    }
}
