import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models.dart/choose_location_cubit/choose_location_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChooseYourLocationPage extends StatefulWidget {
  const ChooseYourLocationPage({super.key});

  @override
  State<ChooseYourLocationPage> createState() => _ChooseYourLocationPageState();
}

class _ChooseYourLocationPageState extends State<ChooseYourLocationPage> {
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _cityController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
        ),
        title: Text(
          "Address",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add New Address 📍",
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  "Let's find an unforgettable location for delivery",
                  style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                ),
                SizedBox(height: 30.h),

                // Add Location Form
                BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
                  bloc: BlocProvider.of<ChooseLocationCubit>(context),
                  listenWhen: (previous, current) =>
                      current is AddLocationSuccess ||
                      current is ConfirmLocationSuccess,
                  listener: (context, state) {
                    if (state is AddLocationSuccess) {
                      _cityController.clear();
                      _countryController.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Location added successfully"),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                      );
                    }
                    if (state is ConfirmLocationSuccess) {
                      Navigator.pop(context);
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is AddLocationLoading ||
                      current is AddLocationSuccess ||
                      current is AddLocationFaliure,
                  builder: (context, state) {
                    return Form(
                      key: _formKey,
                      child: Container(
                        padding: EdgeInsets.all(20.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "City",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: _cityController,
                              decoration: InputDecoration(
                                hintText: "Enter city name",
                                prefixIcon: const Icon(
                                  Icons.location_city,
                                  color: Colors.deepPurple,
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter city name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            Text(
                              "Country",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            TextFormField(
                              controller: _countryController,
                              decoration: InputDecoration(
                                hintText: "Enter country name",
                                prefixIcon: const Icon(
                                  Icons.public,
                                  color: Colors.deepPurple,
                                ),
                                filled: true,
                                fillColor: Colors.grey[50],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter country name";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 20.h),
                            if (state is AddLocationLoading)
                              const Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.deepPurple,
                                  ),
                                ),
                              )
                            else
                              SizedBox(
                                width: double.infinity,
                                height: 50.h,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      final location =
                                          "${_cityController.text}-${_countryController.text}";
                                      BlocProvider.of<ChooseLocationCubit>(
                                        context,
                                      ).setLocation(location);
                                    }
                                  },
                                  icon: Icon(Icons.add, size: 20.sp),
                                  label: Text(
                                    "Add Location",
                                    style: TextStyle(fontSize: 16.sp),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 30.h),

                // Saved Locations
                Text(
                  "Saved Locations",
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 16.h),

                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  bloc: BlocProvider.of<ChooseLocationCubit>(context),
                  buildWhen: (previous, current) =>
                      current is FetchLocationLoading ||
                      current is FetchLocationSuccess ||
                      current is FetchLocationFaliure,
                  builder: (context, state) {
                    if (state is FetchLocationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
                        ),
                      );
                    } else if (state is FetchLocationFaliure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state is FetchLocationSuccess) {
                      final locations = state.locations;
                      if (locations.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 80.sp,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                "No saved locations",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final location = locations[index];
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: CustomLocationItem(
                              location: location,
                              onTap: () {
                                BlocProvider.of<ChooseLocationCubit>(
                                  context,
                                ).chooseLocation(location.id);
                              },
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 20.h),

                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  builder: (context, state) {
                    if (state is ConfirmLocationLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.deepPurple,
                          ),
                        ),
                      );
                    } else if (state is ConfirmLocationFaliure) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return CustomButton(
                      title: "Confirm Location",
                      onTap: () {
                        BlocProvider.of<ChooseLocationCubit>(
                          context,
                        ).confirmLocation();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomLocationItem extends StatelessWidget {
  const CustomLocationItem({
    super.key,
    required this.location,
    required this.onTap,
    this.borderColor,
    this.circleAvatarColor,
  });

  final LocationItemModel location;
  final VoidCallback onTap;
  final Color? borderColor;
  final Color? circleAvatarColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: location.isChosen ? AppColors.primary : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: location.isChosen
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.city,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${location.city}, ${location.country}",
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Container(
              height: 60.h,
              width: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: location.isChosen
                      ? AppColors.primary
                      : Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: location.imgUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (location.isChosen) ...[
              SizedBox(width: 12.w),
              Icon(Icons.check_circle, color: AppColors.primary, size: 28.sp),
            ],
          ],
        ),
      ),
    );
  }
}
