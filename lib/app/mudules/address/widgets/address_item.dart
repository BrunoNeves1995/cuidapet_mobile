part of '../address_page.dart';

class _AddressItem extends StatelessWidget {
  const _AddressItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: const ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 23.0,
          child: Icon(Icons.location_on, color: Colors.black, size: 30.0),
        ),
        title: Text(
          'AV Paulista, 200',
        ),
        subtitle: Text('Complemento x'),
      ), 
    );
  }
}
