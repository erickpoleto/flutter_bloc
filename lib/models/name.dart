import 'package:flutter_bloc/flutter_bloc.dart';

//poderia possuir diversos valores
class NameCubit extends Cubit<String> {
  NameCubit(String name): super(name);

  void change(String name) => emit(name);
}
