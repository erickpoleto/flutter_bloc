import 'package:bytebank/components/container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//exemplo de bloc
class CounterCubit extends Cubit<int> {
  CounterCubit(): super(0);

  void incremet() => emit(state + 1);

  void decrement() => state > 0 ? emit(state - 1) : '';
}

class CounterContainer extends BlocContainer {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: CounterView(),
    );
  }
}


class CounterView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text("Contador")),
      body: Center(
       child: BlocBuilder<CounterCubit, int>(builder: (context, state){
           return Text('$state',
               style: textTheme.headline2
           );
         },
       )
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().incremet(),
            child: Icon(Icons.add),
          ),
          SizedBox(height: 8,),
          FloatingActionButton(
            onPressed: () => context.read<CounterCubit>().decrement(),
            child: Icon(Icons.remove),
          )
        ],
      ),
    );
  }
}
