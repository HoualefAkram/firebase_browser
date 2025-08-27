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
    final Size size = MediaQuery.sizeOf(context);
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
        body: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.all(36),
          child: BlocBuilder<DatabaseCubit, DatabaseState>(
            builder: (context, dbState) {
              if (dbState is DatabaseInitializedState) {
                final Iterable<DbData>? data = dbState.data;
                if (data == null) {
                  return const SizedBox.shrink();
                }
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Theme.of(context).focusColor.withAlpha(20),
                      ),
                      child: Row(
                        children: [
                          TextButton.icon(
                            onPressed: () => {
                              context.read<DatabaseCubit>().backNode(),
                            },
                            label: Text("Back"),
                            icon: Icon(Icons.arrow_back),
                          ),
                          const Spacer(),
                          Text(dbState.currentPath),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: Text("Home"),
                            icon: Icon(Icons.home),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(20),
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Theme.of(context).focusColor,
                        ),
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
                                    child: SelectableText(
                                      "${item.name}: ${item.value}",
                                    ),
                                  );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: SelectableText("Error: unknown state!"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
