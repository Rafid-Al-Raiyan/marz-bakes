import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marz_bakes/backend_services/firestore_services.dart';
import 'package:marz_bakes/ui/admin/update_item_page.dart';

import '../shared/item_page.dart';

class ViewItems extends StatefulWidget {
  const ViewItems({Key? key}) : super(key: key);

  @override
  State<ViewItems> createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ItemPage(),
    );
  }
}
