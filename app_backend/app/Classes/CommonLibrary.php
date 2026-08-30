<?php
namespace App\Classes;
use Session;
use Redirect;
// use Illuminate\Http\Request;
use Request;
use Cookie;
use URL;
use DB;
use App\CommonModel;
use App\Models\Package;
use App\Models\Setting;
use App\Models\Manager;
use File;
use App\Models\Invoice;

use App\Models\Activity;
class CommonLibrary {

    public static function getInvoicePackageTotal($invoice_id = ''){
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('package_price');

        return $package_price * $us_rate;
    }
    public static function addActivity($type,$dateTime,$message,$admin){
        $activities = new Activity();
        $activities->type = $type;
        $activities->activity = $message;
        $activities->responce = '';
        $activities->added_by = $admin;
        $activities->created_at = $dateTime;
        $activities->save();
    }
    public static function getInvoiceServiceTotal($invoice_id = ''){
        $us_rate = DB::table('settings')->first()->us_rate;
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('service_fee');

        return $service_fee * $us_rate;
    }

    public static function getInvoiceCustomTotal($invoice_id = ''){
        $us_rate = DB::table('settings')->first()->us_rate;
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('custom_fee');
        return $custom_fee * $us_rate;
    }
     public static function getOutletID($mailbox = ''){
        $user = DB::table('users')->where('mailbox',  $mailbox)->first();
        if($user){
            return $user->outlet_id;
        }else{
            return '';
        }
    }
    public static function getInvoiceGCT($invoice_id = ''){
        $us_rate = DB::table('settings')->first()->us_rate;
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('service_fee');

        //return $service_fee;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($service_fee > 0){
                $gct = $service_fee * 15 / 100;
                $gct = $gct * $us_rate;
            }else{
                $gct = 0;
            }
        }
        return $gct;
    }

    public static function getUserName($mailbox = ''){
        $user = DB::table('users')->where('mailbox',  $mailbox)->first();
        if($user){
            return $user->first_name.' '.$user->last_name;
        }else{
            return '';
        }
    }
    public static function getUserInfo($mailbox = ''){
        $user = DB::table('users')->where('mailbox',  $mailbox)->first();
        if($user){
            return $user;
        }else{
            return '';
        }
    }



    public static function getSptNumber($invoice_id){
        $packages = DB::table('invoice_packages')
                        ->select('packages.manifest_no')
                        ->join('packages', 'invoice_packages.tracking_no', '=', 'packages.tracking_no')
                        ->where('invoice_packages.invoice_id' , $invoice_id)
                        ->first();
        if($packages){
            return $packages->manifest_no;
        }else{
            return '';
        }

    }
    public static function checkInvoice($tracking_no =  ''){
        $invoice = DB::table('invoice_packages')->join('invoices', 'invoices.invoice_id', '=', 'invoice_packages.invoice_id')->where('invoice_packages.tracking_no' , $tracking_no)->first();
        if($invoice){
            return $invoice->invoice_no;
        }else{
            return 0;
        }
    }
     public static function getCheckPackageStatus($status_id = ''){
        $packages = DB::table('packages')->where('status',  $status_id)->first();
        if($packages){
            return 1;
        }else{
            return 0;
        }
    }
     public static function getPackageAmountMass($tracking_no = '',$invoice_id = ''){
        //return $tracking_no;
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        $us_rate = DB::table('settings')->first()->us_rate;
        // $package = DB::table('invoice_packages')->join('packages', 'invoice_packages.tracking_no', '=', 'packages.tracking_no')->where('invoice_packages.tracking_no' , $tracking_no)->first();
        // if($package){
        //     $custom_fee = $package->custom_fee  * $us_rate;
        //     $service_fee = (int) $package->service_fee * $us_rate;
        //     $package_price = $package->package_price * $us_rate;
        // }else{
        //     $service_fee = 0;
        //     $custom_fee = 0;
        //     $package_price = 0;
        // }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('service_fee');
        //return $service_fee;
        $service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        $service_type = $service_type * $us_rate;
        $sub_total = $package_price + $service_type;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($service_fee > 0){
                $gct = $service_fee * 16.50 / 100;
                $gct = $gct * $us_rate;
            }else{
                $gct = 0;
            }
        }
        $discount = $invoice->discount_price;
        return $total = $sub_total + $gct - $discount;
        //return number_format($package_price + $custom_fee + $service_fee,2);
        //return $package_price + $custom_fee + $service_fee;
    }
    public static function getSptNumbers($tracking_no){
        $tracking_no = explode(',',$tracking_no);
        $packages = DB::table('packages')->select('manifest_no')->whereIn('tracking_no' , $tracking_no)->get();
        return Arr::pluck($packages, 'manifest_no');
    }
    public static function getOutletName($mailbox = ''){
        $user = DB::table('users')->where('mailbox',  $mailbox)->first();
        if($user){
            if($user->outlet_id != 0){
                $outlet = DB::table('outlets')->where('outlet_id',  $user->outlet_id)->first();
                if($outlet){
                    return $outlet->outlet_name;
                }else{
                    return '';
                }
            }else{
                return '';
            }
        }else{
            return '';
        }
    }

    public static function getModues($user_id = '' , $role_id = ''){
        return DB::table('role_modules')->where('user_id', '=', $user_id)->where('role_id', '=', $role_id)->first();
    }

    public static function getInvoiceCountOld($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('package_price');
        $service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $subTotal = $package_price + $service_type + $service_fee;

        if($invoice->gct == 0){
            $gct = 0;
        }else{
             $gct = $subTotal * 15 / 100;
        }
        $total = $subTotal + $gct;
        return $incoiceTotal = $total * $us_rate;
    }
    public static function getmanagerName($id = ''){
        $man= Manager::where('id',  $id)->first();
        if($man){
            return $man->name;
        }else{
            return '';
        }
    } public static function getmanagerphone($id = ''){
        $man= Manager::where('id',  $id)->first();
        if($man){
            return $man->phone;
        }else{
            return '';
        }
    }

    public static function getInvoicePackages($invoice_id = ''){
        return $packages = DB::table('invoice_packages')
                                ->select('packages.*')
                                ->join('packages', 'invoice_packages.tracking_no', '=', 'packages.tracking_no')
                                //->join('users', 'packages.mailbox', '=', 'users.mailbox')
                                //->join('package_status', 'package_status.id', '=', 'packages.status')
                                //->join('outlets', 'outlets.outlet_id', '=', 'users.outlet_id','left')
                                ->where('invoice_packages.status' , 0)
                                ->where('invoice_packages.invoice_id' , $invoice_id)
                                ->get();
    }

    public static function getInvoice($tracking_no = ''){
        $invoice = Invoice::where('tracking_no', '=', $tracking_no)->first();
        if($invoice){
            return $invoice->invoice_no;
        }else{
            return 0;
        }
    }

    public static function getAllInvoiceCountUnpaid($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('service_fee');
        //$service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        //$service_fees = $service_fee * $us_rate;
        //$service_type = $service_type * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($sub_total > 0){
                $gct = $sub_total * 16.50 / 100;
            }else{
                $gct = 0;
            }
        }
        $total = $sub_total + $gct;
        return $total;
    }

    public static function getAllInvoiceCount($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('service_fee');
        //$service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        //$service_fees = $service_fee * $us_rate;
        //$service_type = $service_type * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($sub_total > 0){
                $gct = $sub_total * 16.50 / 100;
            }else{
                $gct = 0;
            }
        }
        $total = $sub_total + $gct;
        return $total;
    }

    public static function getInvoiceCount($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('status' , 0)->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('service_fee');
        //$service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        //$service_fees = $service_fee * $us_rate;
        //$service_type = $service_type * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($sub_total > 0){
                $gct = $sub_total * 16.50 / 100;
            }else{
                $gct = 0;
            }
        }
        $total = $sub_total + $gct + self::getInvoiceStorageFeeAmount($invoice_id);
        return number_format($total,2);
    }

    public static function getInvoiceCountPaid($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 1)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 1)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 1)->sum('service_fee');
        //$service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        //$service_fees = $service_fee * $us_rate;
        //$service_type = $service_type * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($sub_total > 0){
                $gct = $sub_total * 16.50 / 100;
            }else{
                $gct = 0;
            }
        }
        $total = $sub_total + $gct + self::getInvoiceStorageFeeAmount($invoice_id);
        return number_format($total,2);
    }

    public static function getInvoiceCountPaidStaff($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 1)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 1)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 1)->sum('service_fee');
        //$service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        //$service_fees = $service_fee * $us_rate;
        //$service_type = $service_type * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($sub_total > 0){
                $gct = $sub_total * 16.50 / 100;
            }else{
                $gct = 0;
            }
        }
        return $total = $sub_total + $gct + self::getInvoiceStorageFeeAmount($invoice_id);
    }

    public static function getInvoiceCountTotal($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        //$service_fees = $service_fee * $us_rate;
        $service_type = $service_type * $us_rate;
        $sub_total = $package_price + $service_type;
        $serviceFee_total = $service_fee * $us_rate;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($serviceFee_total > 0){
                $gct = $serviceFee_total * 15 / 100;
            }else{
                $gct = 0;
            }
        }
        if($invoice->status == 0){
            $discount_price = 0;
        }else{
            $discount_price = $invoice->discount_price;
        }
        $total = $sub_total + $gct + self::getInvoiceStorageFeeAmount($invoice_id);
        return $total - $discount_price;
    }

     public static function getInvoiceOutstanding($invoice_id = ''){
        $invoice = Invoice::where('invoice_id' , $invoice_id)->first();
        if($invoice){
            $service_fee = $invoice->service_fee;
        }else{
            $service_fee = 0;
        }
        $package_price = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('package_price');
        $custom_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('custom_fee');
        $service_fee = DB::table('invoice_packages')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('service_fee');
        //$service_type = DB::table('service_type')->where('invoice_id' , $invoice_id)->where('status' , 0)->sum('service_fee');
        $us_rate = DB::table('settings')->first()->us_rate;
        $package_price = ($package_price + $custom_fee + $service_fee) * $us_rate;
        $sub_total = $package_price;
        if($invoice->gct == 0){
            $gct = 0;
        }else{
            if($sub_total > 0){
                $gct = $sub_total * 16.50 / 100;
            }else{
                $gct = 0;
            }
        }
        return $total = $sub_total + $gct + self::getInvoiceStorageFeeAmount($invoice_id);
    }

    public static function getInvoiceStorageFeeAmount($invoice_id = ''){
        if($invoice_id == ''){
            return 0;
        }
        if(!DB::getSchemaBuilder()->hasTable('invoice_storage_fees')){
            return 0;
        }

        $storage_fee = DB::table('invoice_storage_fees')
            ->where('invoice_id', $invoice_id)
            ->where(function($query) {
                $query->where('active', 1)
                    ->orWhere('included_in_payment', 1);
            })
            ->orderBy('updated_at', 'DESC')
            ->value('fee_amount');

        return (float) ($storage_fee ?? 0);
    }

    public static function getPackageAmount($tracking_no = ''){
        //return $tracking_no;
        $us_rate = DB::table('settings')->first()->us_rate;
        $package = DB::table('invoice_packages')->join('packages', 'invoice_packages.tracking_no', '=', 'packages.tracking_no')->where('invoice_packages.tracking_no' , $tracking_no)->first();
        //dd($package_price);

        if($package){
            $custom_fee = $package->custom_fee  * $us_rate;
            $service_fee = $package->service_fee  * $us_rate;
            $package_price = $package->package_price * $us_rate;
        }else{
            $service_fee = 0;
            $custom_fee = 0;
            $package_price = 0;
        }

        //return $price;
        // $package_price = DB::table('invoice_packages')->where('tracking_no' , $tracking_no)->sum('package_price');
        // $custom_fee = DB::table('invoice_packages')->where('tracking_no' , $tracking_no)->sum('custom_fee');

        // $subTotal = $package_price + $price;
        // $total = $subTotal;
        // return $custom_fee = $custom_fee * $us_rate;
        // return $incoiceTotal = $total * $us_rate;
        return number_format($package_price + $custom_fee + $service_fee, 2, '.', '');
    }

    public static function textLimit($text = '',$limit = ''){
        if(strlen($text) > $limit){
            return $text  = substr($text,0,$limit).'...';
        }else{
          return  $text;
        }
    }

    public static function getSettings(){
        return $settings = Setting::first();
    }
    public static function getCheckPermission($module_id = ''){
        $role_id = Session::get('role_id');
        $role_permissions = DB::table('role_permissions')->where('module_id' , $module_id)->where('role_id' , $role_id)->first();
        return $role_permissions;
    }
    public static function getPermission($module_id = '' , $role_id = ''){
        $role_permissions = DB::table('role_permissions')->where('module_id' , $module_id)->where('role_id' , $role_id)->first();
        return $role_permissions;
    }
    public static function getRolePermission($type = ''){
        $role_id = Session::get('role_id');
        $userPermission = DB::table('role_modules_new')
                            ->select('role_modules_new.*','role_permissions.*')
                            ->join('role_permissions', 'role_permissions.module_id', '=', 'role_modules_new.id')
                            ->where('role_modules_new.type' , $type)
                            ->where('role_permissions.role_id' , $role_id)
                            ->get();
        if(count($userPermission) > 0){
            return $userPermission;
        }else{
            return $userPermission;
        }
    }

    public static function firebase($device_token,$message,$notification) {;
        $file = url('public/straight-to-yards-cb6b28a44dba.json');
        //$file = 'https://aptteamja.com/public/sendx-83d4c-135b1cc0fdd9.json';
        $serviceAccountJson = json_decode(file_get_contents($file), true);
        $accessToken = CommonLibrary::getAccessToken($serviceAccountJson);
        //Notifcation Types
        //newemployee for register for new employee
        //newmessage for new message
        //newgroup for create of new group
        //addgroupmember for add new member to group
        //newfriendrequest for send request
        //friendrequestaccepted for send request


        // Message should contain key and value. It should be an array like =====  message=>'Hi test'
        $url = 'https://fcm.googleapis.com/v1/projects/straight-to-yards/messages:send';
        $mainObj = [
            'message' => [
                'token' => $device_token,
                'notification' => $notification,
                'data' => $message,
            ],
        ];
        //return json_encode($mainObj);
        // $fields = array(
        //     'registration_ids' => $device_token,
        //     'content_available' => true,
        //     'mutable_content' => true,
        //     'data' => $message,
        //     'notification' =>  $message
        // );
        //echo json_encode($fields);exit;
        // Authentication..... Identification for project on firebase

        $header = array(
            'Authorization: Bearer '.$accessToken,
            'Content-Type: application/json'
        );
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_POST, TRUE);
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, TRUE);
        curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
        curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($mainObj));
        $result = curl_exec($ch);
        //echo '<pre>'; print_r($result);exit;
        if ($result === false) {
            die('Curl Failed: ' . curl_error($ch));
        }

        curl_close($ch);
        return $result;
    }

    public static function getAccessToken($serviceAccountJson) {
        $jwtHeader = json_encode(['alg' => 'RS256', 'typ' => 'JWT']);
        $now = time();
        $jwtClaimSet = json_encode([
            'iss' => $serviceAccountJson['client_email'],
            'scope' => 'https://www.googleapis.com/auth/firebase.messaging',
            'aud' => $serviceAccountJson['token_uri'],
            'exp' => $now + 3600,  // 1 hour expiration
            'iat' => $now,
        ]);

        $jwtBase64 = base64_encode($jwtHeader) . '.' . base64_encode($jwtClaimSet);
        $signature = '';
        openssl_sign($jwtBase64, $signature, $serviceAccountJson['private_key'], 'sha256WithRSAEncryption');
        $jwt = $jwtBase64 . '.' . base64_encode($signature);

        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $serviceAccountJson['token_uri']);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_POST, true);
        curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query([
            'grant_type' => 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            'assertion' => $jwt,
        ]));

        $response = curl_exec($ch);
        curl_close($ch);

        if ($response === false) {
            throw new Exception('Error getting access token');
        }

        $jsonResponse = json_decode($response, true);
        return $jsonResponse['access_token'];
    }
}

?>
