import 'package:firebase_browser/features/core/assets/icons/icons.dart';
import 'package:firebase_browser/features/core/helpers/loading/loading_screen.dart';
import 'package:firebase_browser/features/db_management/blocs/db_cubit/db_cubit.dart';
import 'package:firebase_browser/features/db_management/dialogs/db_info_dialog.dart';
import 'package:firebase_browser/features/db_management/dialogs/delete_db_dialog.dart';
import 'package:firebase_browser/features/db_management/models/remote_db.dart';
import 'package:firebase_browser/features/db_management/screens/data_view.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'dart:developer' as dev show log;

class DbSelectionView extends StatefulWidget {
  const DbSelectionView({super.key});

  @override
  State<DbSelectionView> createState() => _DbSelectionViewState();
}

class _DbSelectionViewState extends State<DbSelectionView> {
  Set<RemoteDatabase> hovered = <RemoteDatabase>{};

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<DatabaseCubit>().loadDatabases();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final int crossAxisCount = max(1, size.width ~/ 300);
    return BlocConsumer<DatabaseCubit, DatabaseState>(
      listener: (context, dbState) {
        if (dbState.isLoading) {
          LoadingScreen().show(context: context);
        } else {
          LoadingScreen().hide();
        }
      },
      builder: (context, dbState) {
        return Scaffold(
          body: Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.all(36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.25,
                  child: Image.asset(AppIcons.firebaseHorizontalFull),
                ),
                Row(
                  children: [
                    Text(
                      "Available Databases",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Spacer(),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () async {
                          final RemoteDatabase? remoteDb =
                              await showDbInfoDialog(context);
                          if (remoteDb == null || !context.mounted) return;
                          context.read<DatabaseCubit>().addDatabase(
                            url: remoteDb.url,
                            name: remoteDb.name,
                          );
                        },
                        child: const Text("+ Database"),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Builder(
                  builder: (context) {
                    if (dbState is DatabaseInitializedState) {
                      return Expanded(
                        child: Container(
                          padding: EdgeInsets.all(20),
                          width: size.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).focusColor,
                          ),
                          child: dbState.dbs.isNotEmpty
                              ? GridView.builder(
                                  itemCount: dbState.dbs.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: crossAxisCount,
                                        childAspectRatio: 3,
                                      ),
                                  itemBuilder: (context, index) {
                                    final RemoteDatabase db =
                                        dbState.dbs[index];
                                    final bool isHovered = hovered.contains(db);

                                    return MouseRegion(
                                      onEnter: (event) => setState(() {
                                        hovered.add(db);
                                      }),
                                      onExit: (event) => setState(() {
                                        hovered.remove(db);
                                      }),
                                      child: InkWell(
                                        customBorder: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadiusGeometry.circular(16),
                                        ),
                                        onTap: () async {
                                          await context
                                              .read<DatabaseCubit>()
                                              .selectDb(db.url);
                                          if (!context.mounted) return;
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => DataView(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          margin: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).primaryColor,
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),

                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 26,
                                                  child: Image.asset(
                                                    AppIcons.firebaseIconMono,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Expanded(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        db.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      Text(
                                                        db.url,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (isHovered)
                                                  IconButton(
                                                    onPressed: () async {
                                                      final bool delete =
                                                          await showDeleteDbDialog(
                                                            context,
                                                          ) ??
                                                          false;
                                                      if (!delete ||
                                                          !context.mounted) {
                                                        return;
                                                      }
                                                      context
                                                          .read<DatabaseCubit>()
                                                          .deleteDatabase(db);
                                                    },
                                                    icon: const Icon(
                                                      Icons.delete,
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(child: Text("No Databases Available.")),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
