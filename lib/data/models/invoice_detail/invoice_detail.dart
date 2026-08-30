import 'package:json_annotation/json_annotation.dart';

part 'invoice_detail.g.dart';

@JsonSerializable()
class InvoiceDetailResponse {
  @JsonKey(name: 'invoice_id', defaultValue: -1)
  final int invoiceId;
  @JsonKey(name: 'invoice_no', defaultValue: -1)
  final int invoiceNo;
  @JsonKey(name: 'mailbox_no', defaultValue: '')
  final String mailboxNo;
  @JsonKey(name: 'user_name', defaultValue: '')
  final String userName;
  @JsonKey(name: 'gct', defaultValue: -1)
  final int gct;
  @JsonKey(name: 'discount_price', defaultValue: '')
  final String discountPrice;
  @JsonKey(name: 'date_paid', defaultValue: '')
  final String datePaid;
  @JsonKey(name: 'email', defaultValue: '')
  final String email;
  @JsonKey(name: 'address_1', defaultValue: '')
  final String address1;
  @JsonKey(name: 'company_name', defaultValue: '')
  final String companyName;
  @JsonKey(name: 'local_address', defaultValue: '')
  final String localAddress;
  @JsonKey(name: 'gst_persent', defaultValue: '')
  final String gstPersent;
  @JsonKey(name: 'gst_total', defaultValue: '')
  final String gstTotal;
  @JsonKey(name: 'sub_total', defaultValue: '')
  final String subTotal;
  @JsonKey(name: 'grand_total', defaultValue: '')
  final String grandTotal;
  @JsonKey(name: 'storage_fee_total', defaultValue: '0')
  final String storageFeeTotal;
  @JsonKey(name: 'storage_fee')
  final StorageFee? storageFee;
  @JsonKey(name: 'site_email', defaultValue: '')
  final String siteEmail;
  @JsonKey(name: 'phone', defaultValue: '')
  final String phone;
  @JsonKey(name: 'freight_type', defaultValue: '')
  final String freightType;
  @JsonKey(name: 'invoice_detail', defaultValue: [])
  final List<InvoiceDetail> invoiceDetail;
  @JsonKey(name: 'additional_fee', defaultValue: [])
  final List<AdditionalFee>? additionalFee;

  const InvoiceDetailResponse({
    required this.invoiceId,
    required this.invoiceNo,
    required this.mailboxNo,
    required this.userName,
    required this.gct,
    required this.discountPrice,
    required this.datePaid,
    required this.email,
    required this.address1,
    required this.companyName,
    required this.localAddress,
    required this.gstPersent,
    required this.gstTotal,
    required this.subTotal,
    required this.grandTotal,
    required this.storageFeeTotal,
    required this.storageFee,
    required this.invoiceDetail,
    required this.siteEmail,
    required this.phone,
    required this.additionalFee,
    required this.freightType,
  });

  factory InvoiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return _$InvoiceDetailResponseFromJson(json);
  }
  factory InvoiceDetailResponse.empty() {
    return const InvoiceDetailResponse(
      address1: '',
      companyName: '',
      datePaid: '',
      discountPrice: '',
      email: '',
      gct: -1,
      grandTotal: '',
      storageFeeTotal: '0',
      storageFee: null,
      gstPersent: '',
      gstTotal: '',
      invoiceDetail: [],
      invoiceId: -1,
      invoiceNo: -1,
      localAddress: '',
      mailboxNo: '',
      subTotal: '',
      userName: '',
      siteEmail: '',
      phone: '',
      additionalFee: [],
      freightType: '',
    );
  }

  Map<String, dynamic> toJson() => _$InvoiceDetailResponseToJson(this);
}

@JsonSerializable()
class StorageFee {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;
  @JsonKey(name: 'invoice_id', defaultValue: -1)
  final int invoiceId;
  @JsonKey(name: 'storage_start_date', defaultValue: '')
  final String storageStartDate;
  @JsonKey(name: 'last_calculated_date', defaultValue: '')
  final String lastCalculatedDate;
  @JsonKey(name: 'storage_days', defaultValue: 0)
  final int storageDays;
  @JsonKey(name: 'fee_amount', defaultValue: '0')
  final dynamic feeAmount;
  @JsonKey(name: 'undelivered_packages', defaultValue: 0)
  final int undeliveredPackages;
  @JsonKey(name: 'active', defaultValue: 0)
  final dynamic active;
  @JsonKey(name: 'included_in_payment', defaultValue: 0)
  final dynamic includedInPayment;

  const StorageFee({
    required this.id,
    required this.invoiceId,
    required this.storageStartDate,
    required this.lastCalculatedDate,
    required this.storageDays,
    required this.feeAmount,
    required this.undeliveredPackages,
    required this.active,
    required this.includedInPayment,
  });

  factory StorageFee.fromJson(Map<String, dynamic> json) {
    return _$StorageFeeFromJson(json);
  }

  Map<String, dynamic> toJson() => _$StorageFeeToJson(this);
}

@JsonSerializable()
class InvoiceDetail {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;
  @JsonKey(name: 'invoiceId', defaultValue: -1)
  final int invoiceId;
  @JsonKey(name: 'tracking_no', defaultValue: '')
  final String trackingNo;
  @JsonKey(name: 'package_description', defaultValue: '')
  final String packageDescription;
  @JsonKey(name: 'package_price', defaultValue: '')
  final String packagePrice;
  @JsonKey(name: 'custom_fee', defaultValue: '')
  final String customFee;
  @JsonKey(name: 'service_fee', defaultValue: '')
  final String serviceFee;
  @JsonKey(name: 'package_weight', defaultValue: 0)
  final int packageWeight;
  @JsonKey(name: 'status', defaultValue: 0)
  final int status;
  @JsonKey(name: 'package_total', defaultValue: '')
  final String packageTotal;
  @JsonKey(name: 'manifest_no', defaultValue: '')
  final String manifestNo;

  InvoiceDetail({
    required this.id,
    required this.invoiceId,
    required this.trackingNo,
    required this.packageDescription,
    required this.packagePrice,
    required this.customFee,
    required this.serviceFee,
    required this.packageWeight,
    required this.status,
    required this.packageTotal,
    required this.manifestNo,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) {
    return _$InvoiceDetailFromJson(json);
  }
  Map<String, dynamic> toJson() => _$InvoiceDetailToJson(this);
}

@JsonSerializable()
class AdditionalFee {
  @JsonKey(name: 'id', defaultValue: -1)
  final int id;
  @JsonKey(name: 'invoice_id', defaultValue: '')
  final String invoiceId;
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  @JsonKey(name: 'service_fee', defaultValue: '0')
  final String serviceFee;

  AdditionalFee({
    required this.id,
    required this.invoiceId,
    required this.name,
    required this.serviceFee,
  });

  factory AdditionalFee.fromJson(Map<String, dynamic> json) {
    return _$AdditionalFeeFromJson(json);
  }
  Map<String, dynamic> toJson() => _$AdditionalFeeToJson(this);
}
