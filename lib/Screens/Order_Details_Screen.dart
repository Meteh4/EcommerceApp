import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoptral1/db/Order_Helper.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  OrderDetailsScreen({required this.order});

  @override
  _OrderDetailsScreenState createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  CollectionReference _commentsCollection =
  FirebaseFirestore.instance.collection('comments');
  late Stream<QuerySnapshot> _commentsStream;

  @override
  void initState() {
    super.initState();
    _commentsStream = _commentsCollection
        .where('orderId', isEqualTo: widget.order['id'])
        .snapshots();
  }

  @override
  void dispose() {
    _commentController.dispose();
    _ratingController.dispose();
    super.dispose();
  }

  Future<void> _addComment() async {
    String comment = _commentController.text.trim();
    double rating = double.parse(_ratingController.text.trim());

    if (comment.isNotEmpty && rating >= 0 && rating <= 5) {
      Map<String, dynamic> commentData = {
        'orderId': widget.order['id'],
        'comment': comment,
        'rating': rating,
      };
      await _commentsCollection.add(commentData);
      _commentController.clear();
      _ratingController.clear();
    }
  }

  Future<void> _editComment(DocumentSnapshot comment) async {
    String updatedComment = _commentController.text.trim();
    double updatedRating = double.parse(_ratingController.text.trim());

    if (updatedComment.isNotEmpty && updatedRating >= 0 && updatedRating <= 5) {
      Map<String, dynamic> commentData = {
        'comment': updatedComment,
        'rating': updatedRating,
      };
      await _commentsCollection.doc(comment.id).update(commentData);
      _commentController.clear();
      _ratingController.clear();
    }
  }

  Future<void> _deleteComment(DocumentSnapshot comment) async {
    await _commentsCollection.doc(comment.id).delete();
  }

  Future<void> _deleteOrder() async {
    await OrderHelper.openOrdersDatabase().then((database) {
      return database
          .delete('siparisler', where: 'id = ?', whereArgs: [widget.order['id']]);
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDAD3C8),
      appBar: AppBar(
        backgroundColor: const Color(0xffDAD3C8),
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Title: ${widget.order['title']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Category: ${widget.order['category']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Price: \$${widget.order['price']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Quantity: ${widget.order['quantity']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Comments',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: _commentsStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<DocumentSnapshot> comments = snapshot.data!.docs;
                    if (comments.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No comments found'),
                      );
                    } else {
                      return Column(
                        children: comments
                            .map(
                              (comment) => ListTile(
                            title: Text(comment['comment']),
                            subtitle: RatingBar.builder(
                              initialRating: comment['rating'],
                              minRating: 0,
                              maxRating: 5,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 20,
                              itemBuilder: (context, _) => const Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (_) {},
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    _commentController.text =
                                    comment['comment'];
                                    _ratingController.text =
                                        comment['rating'].toString();
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Edit Comment'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _commentController,
                                              decoration: const InputDecoration(
                                                labelText: 'Comment',
                                                border:
                                                OutlineInputBorder(),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            RatingBar.builder(
                                              initialRating:
                                              comment['rating'],
                                              minRating: 0,
                                              maxRating: 5,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              itemCount: 5,
                                              itemSize: 40,
                                              itemBuilder: (context, _) =>
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.amber,
                                                  ),
                                              onRatingUpdate: (rating) {
                                                _ratingController.text =
                                                    rating.toString();
                                              },
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _editComment(comment);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Save'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Comment'),
                                        content: const Text(
                                            'Are you sure you want to delete this comment?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () {
                                              _deleteComment(comment);
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                            .toList(),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              const Divider(),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'Add a Comment',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                    labelText: 'Comment',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RatingBar.builder(
                  initialRating: 0,
                  minRating: 0,
                  maxRating: 5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 40,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    _ratingController.text = rating.toString();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _addComment,
                  child: const Text('Add Comment'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: _deleteOrder,
                  child: const Text('Delete Order'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}