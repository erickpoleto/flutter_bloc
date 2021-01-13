import 'package:bytebank/components/container.dart';
import 'package:bytebank/components/progress.dart';
import 'package:bytebank/database/dao/contact_dao.dart';
import 'package:bytebank/models/contact.dart';
import 'package:bytebank/screens/contact_form.dart';
import 'package:bytebank/screens/transaction_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class ListState {
  const ListState();
}

@immutable
class InitState extends ListState {
  const InitState();
}

@immutable
class LoadingState extends ListState {
  const LoadingState();
}

@immutable
class LoadedState extends ListState {
  final List data;
  const LoadedState(this.data);
}

@immutable
class FatalState extends ListState {
  const FatalState();
}

class ContactsListCubit extends Cubit<ListState> {
  ContactsListCubit() : super(InitState());

  void reload(dao) async {
    emit(LoadingState());
    dao.findAll()
    .then((contacts) => emit(LoadedState(contacts)));
  }

}

class ContactsListContainer extends BlocContainer {

  @override
  Widget build(BuildContext context) {
    final ContactDao _dao = ContactDao();
    return BlocProvider<ContactsListCubit>(
        create: (BuildContext context) {
          final cubit = ContactsListCubit();
          cubit.reload(_dao);
          return cubit;
        },
        child: ContactsList(_dao)
    );
  }

}

class ContactsList extends StatelessWidget {
  final ContactDao dao;

  ContactsList(this.dao);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transfer'),
      ),
      body: BlocBuilder<ContactsListCubit, ListState>(
        builder: (context, state) {
          if(state is InitState || state is LoadingState) {
            return Progress();
          }
          if(state is LoadedState) {
            final contacts = state.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                final contact = contacts[index];
                return _ContactItem(
                  contact,
                  onClick: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TransactionFormContainer(contact),
                      ),
                    );
                  },
                );
              },
              itemCount: contacts.length,
            );
          }
          return Text('Unknown error');
        },
      ),
      floatingActionButton: buildAddContactButton(context),
    );
  }

  FloatingActionButton buildAddContactButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ContactForm(),
          ),
        ).then((val) => update(context));
      },
      child: Icon(
        Icons.add,
      ),
    );
  }

  void update(BuildContext context) => context.read<ContactsListCubit>().reload(dao);
}

class _ContactItem extends StatelessWidget {
  final Contact contact;
  final Function onClick;

  _ContactItem(
    this.contact, {
    @required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => onClick(),
        title: Text(
          contact.name,
          style: TextStyle(
            fontSize: 24.0,
          ),
        ),
        subtitle: Text(
          contact.accountNumber.toString(),
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
