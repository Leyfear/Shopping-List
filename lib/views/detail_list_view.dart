import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../cubits/item_detail_cubit/detail_cubit_state.dart';
import '../utils/app_layout.dart';

class DetailList extends StatelessWidget {
  final CurrentDetailListState state;

  const DetailList({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.only(bottom: AppLayout.getHeight(10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height * 0.06,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Text(
                  state.currentList[index].name,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              Gap(AppLayout.getWidth(10)),
              Expanded(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.04,
                  height: MediaQuery.of(context).size.height * 0.06,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      state.currentList[index].quantity.toString(),
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      itemCount: state.currentList.length,
    );

  }
}
