import 'package:flutter/material.dart';
import 'package:stockv/Models/transaction.dart';
import 'package:stockv/Utilities/user_wallet_information_requests.dart';

import '../Models/user.dart';
import '../Utilities/global_variables.dart';

class TransactionListPage extends StatefulWidget {
  final User user;

  const TransactionListPage({super.key, required this.user});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  @override
  void initState() {
    super.initState();
    fetchTransactions(widget.user.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leadingWidth: 400,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                Image.asset('images/black.png'),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          const Text('Transaction List',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ListTile(
                      leading: SizedBox(
                        width: 70.0,
                        height: 40.0,
                        child: Column(
                          children: [
                            Icon(
                              Icons.currency_bitcoin,
                              color: transactions[index].sellingTransaction
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            Text(
                              transactions[index].sellingTransaction
                                  ? "Sell"
                                  : "Purchase",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            )
                          ],
                        ),
                      ),
                      title: Text(
                        transactions[index].coinName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      subtitle: Text(
                        transactions[index].date.toString(),
                        style: const TextStyle(
                          fontSize: 17.0,
                        ),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '\$${transactions[index].coinPrice.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          ),
                          Text(
                            transactions[index].coinAmount.toStringAsFixed(2),
                            style: const TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchTransactions(String userId) async {
    List<Transaction> transactionList =
        await getUserTransactionHistory(widget.user.id);
    if (mounted) {
      setState(() {
        transactions = transactionList;
      });
    }
  }
}

