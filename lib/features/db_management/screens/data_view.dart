import 'package:firebase_browser/features/core/helpers/loading/loading_screen.dart';
import 'package:firebase_browser/features/db_management/blocs/db_cubit/db_cubit.dart';
import 'package:firebase_browser/features/db_management/models/db_data.dart';
import 'package:firebase_browser/features/db_management/models/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DataView extends StatelessWidget {
  const DataView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<DatabaseCubit, DatabaseState>(
      listener: (context, dbState) {
        if (dbState.quit ?? false) {
          Navigator.of(context).pop();
        }
        if (dbState.isLoading) {
          LoadingScreen().show(context: context);
        } else {
          LoadingScreen().hide();
        }
      },
      child: Scaffold(
        body: BlocBuilder<DatabaseCubit, DatabaseState>(
          builder: (context, dbState) {
            if (dbState is DatabaseInitializedState) {
              final Iterable<DbData>? data = dbState.data;
              if (data == null) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: TextButton.icon(
                      onPressed: () => {
                        context.read<DatabaseCubit>().backNode(),
                      },
                      label: Text("Back"),
                      icon: Icon(Icons.arrow_back),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final DbData item = data.elementAt(index);
                        return item is Node
                            ? TextButton(
                                onPressed: () {
                                  context.read<DatabaseCubit>().load(item);
                                },
                                child: Text(item.name),
                              )
                            : TextButton(
                                onPressed: null,
                                child: Text("${item.name}: ${item.value}"),
                              );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: Text("Error: unknown state!"));
            }
          },
        ),
      ),
    );
  }
}
