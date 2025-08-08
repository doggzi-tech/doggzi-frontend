import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/address_controller.dart';
import '../../models/address_model.dart';

class AddressFormPage extends StatefulWidget {
  const AddressFormPage({super.key});

  @override
  State<AddressFormPage> createState() => _AddressFormPageState();
}

class _AddressFormPageState extends State<AddressFormPage> {
  final AddressController c = Get.find();
  final _formKey = GlobalKey<FormState>();

  late AddressModel model;

  final TextEditingController nameCtl = TextEditingController();
  final TextEditingController phoneCtl = TextEditingController();
  final TextEditingController flatCtl = TextEditingController();
  final TextEditingController areaCtl = TextEditingController();
  final TextEditingController cityCtl = TextEditingController();
  final TextEditingController pinCtl = TextEditingController();

  String label = 'Home';

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['addressCandidate'] != null) {
      model = args['addressCandidate'] as AddressModel;
    } else {
      model = AddressModel(
        userId: 'u1',
        receiverName: '',
        receiverPhone: '',
        flat: '',
        area: '',
        city: '',
        state: '',
        postalCode: '',
        country: '',
        lat: 18.5204,
        lng: 73.8567,
      );
    }
    nameCtl.text = model.receiverName;
    phoneCtl.text = model.receiverPhone;
    flatCtl.text = model.flat;
    areaCtl.text = model.area;
    cityCtl.text = model.city;
    pinCtl.text = model.postalCode;
    label = model.label;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SELECT LOCATION'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (model.lat != null && model.lng != null)
                Row(children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  SizedBox(width: 8.w),
                  Expanded(
                      child: Text(
                          '${model.city}  •  ${model.receiverName} ${model.receiverPhone}',
                          style: TextStyle(fontSize: 14.sp))),
                ]),
              SizedBox(height: 12.h),
              TextFormField(
                  controller: nameCtl,
                  decoration: InputDecoration(labelText: 'Receiver Name'),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              SizedBox(height: 10.h),
              TextFormField(
                  controller: phoneCtl,
                  decoration: InputDecoration(labelText: 'Phone'),
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null),
              SizedBox(height: 10.h),
              TextFormField(
                  controller: flatCtl,
                  decoration:
                      InputDecoration(labelText: 'House / Flat / Block No.')),
              SizedBox(height: 10.h),
              TextFormField(
                  controller: areaCtl,
                  decoration:
                      InputDecoration(labelText: 'Apartment / Road / Area')),
              SizedBox(height: 10.h),
              TextFormField(
                  controller: cityCtl,
                  decoration: InputDecoration(labelText: 'City')),
              SizedBox(height: 10.h),
              TextFormField(
                  controller: pinCtl,
                  decoration: InputDecoration(labelText: 'Pin')),
              SizedBox(height: 12.h),
              Text('Save As', style: TextStyle(fontSize: 13.sp)),
              SizedBox(height: 8.h),
              Row(
                children: ['Home', 'Work', 'Other'].map((t) {
                  final active = t == label;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: ChoiceChip(
                      label: Text(t),
                      selected: active,
                      onSelected: (_) {
                        setState(() {
                          label = t;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 18.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    padding: EdgeInsets.symmetric(vertical: 14.h)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    model.receiverName = nameCtl.text.trim();
                    model.receiverPhone = phoneCtl.text.trim();
                    model.flat = flatCtl.text.trim();
                    model.area = areaCtl.text.trim();
                    model.city = cityCtl.text.trim();
                    model.postalCode = pinCtl.text.trim();
                    model.label = label;
                    c.saveAddress(model);
                    Get.back(); // return to list
                  }
                },
                child: Text('Confirm', style: TextStyle(fontSize: 16.sp)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
