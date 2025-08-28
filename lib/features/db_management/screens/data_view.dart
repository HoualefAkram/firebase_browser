import 'package:firebase_browser/features/core/helpers/loading/loading_screen.dart';
import 'package:firebase_browser/features/db_management/blocs/db_cubit/db_cubit.dart';
import 'package:firebase_browser/features/db_management/models/db_data.dart';
import 'package:firebase_browser/features/db_management/models/node.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnPathItemClicked = void Function(String itemPath);

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
                          _buildPathWidget(
                            path: dbState.currentPath,
                            onClicked: (itemPath) {
                              context.read<DatabaseCubit>().jumpTo(
                                path: itemPath,
                              );
                            },
                          ),
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

  Widget _buildPathWidget({
    required String path,
    required OnPathItemClicked onClicked,
  }) {
    final List<String> nodes = path.split("/");
    return Expanded(
      child: SizedBox(
        height: 32,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: nodes.length,
          itemBuilder: (context, index) {
            final String node = nodes[index];
            return Row(
              children: [
                Container(
                  margin: EdgeInsets.all(2),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      minimumSize: Size(10, 10),
                    ),
                    onPressed: () {
                      final String itemPath = nodes
                          .sublist(0, index + 1)
                          .join("/");
                      onClicked.call(itemPath);
                    },
                    child: Text(node),
                  ),
                ),
                Text("/"),
              ],
            );
          },
        ),
      ),
    );
  }
}
