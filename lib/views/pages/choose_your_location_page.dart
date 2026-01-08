import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ecommerce_app/models/add_location_model.dart';
import 'package:flutter_ecommerce_app/utils/app_colors.dart';
import 'package:flutter_ecommerce_app/view_models.dart/choose_location_cubit/choose_location_cubit.dart';
import 'package:flutter_ecommerce_app/views/widgets/custom_button.dart';

class ChooseYourLocationPage extends StatelessWidget {
  const ChooseYourLocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController textEditingController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text(
          "Address",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose your location",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Let's find an unforgettable event. Choose a location below to get started",
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge!.copyWith(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 36),

                BlocConsumer<ChooseLocationCubit, ChooseLocationState>(
                  bloc: BlocProvider.of<ChooseLocationCubit>(context),
                  listenWhen: (previous, current) =>
                      current is AddLocationSuccess ||
                      current is ConfirmLocationSuccess,
                  listener: (context, state) {
                    if (state is AddLocationSuccess) {
                      textEditingController.clear();
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
                    if (state is AddLocationLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is AddLocationFaliure) {
                      return Center(child: Text(state.message));
                    }

                    return TextField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.location_pin,
                          color: Colors.grey.shade600,
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: "Write your location",
                        suffixIcon: IconButton(
                          onPressed: () {
                            BlocProvider.of<ChooseLocationCubit>(
                              context,
                            ).setLocation(textEditingController.text);
                          },
                          icon: Icon(Icons.add, color: Colors.grey.shade600),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 36),
                Text(
                  "Select Location",
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  bloc: BlocProvider.of<ChooseLocationCubit>(context),
                  buildWhen: (previous, current) =>
                      current is FetchLocationLoading ||
                      current is FetchLocationSuccess ||
                      current is FetchLocationFaliure,
                  builder: (context, state) {
                    if (state is FetchLocationLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is FetchLocationFaliure) {
                      return Center(child: Text(state.message));
                    } else if (state is FetchLocationSuccess) {
                      final locations = state.locations;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: locations.length,
                        itemBuilder: (context, index) {
                          final location = locations[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
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
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
                BlocBuilder<ChooseLocationCubit, ChooseLocationState>(
                  builder: (context, state) {
                    if (state is ConfirmLocationLoading) {
                      return const Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    } else if (state is ConfirmLocationFaliure) {
                      return Center(child: Text(state.message));
                    }
                    return CustomButton(
                      title: "Confirm",
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
    return InkWell(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: location.isChosen ? AppColors.primary : Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.city,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${location.city}, ${location.country}",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              CircleAvatar(
                radius: 55,
                backgroundColor: location.isChosen
                    ? circleAvatarColor ?? AppColors.primary
                    : Colors.grey.shade500,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: CachedNetworkImageProvider(location.imgUrl),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
