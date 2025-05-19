// import 'package:bookverse/controller/trailController.dart';
// import 'package:bookverse/widgets/dialogs.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class FollowedTrailsscreen extends StatefulWidget {
//   final String userId;
//   const FollowedTrailsscreen({super.key, required this.userId});

//   @override
//   State<FollowedTrailsscreen> createState() => _FollowedTrailsscreenState();
// }

// class _FollowedTrailsscreenState extends State<FollowedTrailsscreen> {
//   List<dynamic> trails = [];
//   bool isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _loadTrails();
//   }

//   Future<void> _loadTrails() async {
//     final trailList = await TrailController.fetchTrailsFollowed(widget.userId);
//     setState(() {
//       trails = List.from(trailList);
//       isLoading = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//       title: const Text(
//         "Followed trails",
//         style: TextStyle(
//           fontWeight: FontWeight.w500,
//           fontSize: 20, 
//           color: Colors.black87, 
//         ),
//       ),
//       backgroundColor: const Color(0xFFFFDCAA), 
//       elevation: 0,
//     ),
//       body: SafeArea(
//         child: SingleChildScrollView( 
//           child: Column(
//             children: [
//               const SizedBox(height: 60),  
//               const Text(
//                 "Trails List",
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//               const SizedBox(height: 60),  
//               isLoading
//                   ? const Center(child: CircularProgressIndicator())
//                   : Column(
//                     children: [
//                       trails.isEmpty
//                           ? const Center(child: Text("No trails available."))
//                           : ListView.builder(
//                               shrinkWrap: true,
//                               itemCount: trails.length,
//                               itemBuilder: (context, index) {
//                                 final trail = trails[index];
//                                 if (trail['deleted'] == true) {
//                                   return Card(
//                                     color: Colors.grey.shade300,
//                                     margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
//                                     elevation: 1,
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                          ListTile(
//                                             title: Text(
//                                               trail['title'] ?? 'No Title',
//                                               style: const TextStyle(
//                                                 fontSize: 14,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Colors.black87,
//                                               ),
//                                             ),
//                                             subtitle: Column(
//                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                               children: [
//                                                 Text(
//                                                   trail['description'] ?? 'No description available',
//                                                   style: const TextStyle(
//                                                     color: Colors.black45,
//                                                     fontSize: 12,
//                                                   ),
//                                                   maxLines: 5,
//                                                   overflow: TextOverflow.ellipsis,
//                                                 ),
//                                                 const SizedBox(height: 6),
//                                                 GestureDetector(
//                                                   onTap: () async {
//                                                     bool? unfollowConfirmed = await showDialog<bool>(
//                                                       context: context,
//                                                       builder: (BuildContext context) {
//                                                         return AlertDialog(
//                                                           backgroundColor: Colors.white,
//                                                           contentPadding: EdgeInsets.zero,
//                                                           shape: RoundedRectangleBorder(
//                                                             borderRadius: BorderRadius.circular(16),  
//                                                           ),
//                                                           title: const Column(
//                                                             children: [
//                                                               Text(
//                                                                 'Unavailable -> UNFOLLOW Trail', 
//                                                                 style: TextStyle(
//                                                                   color: Colors.black87,
//                                                                   fontWeight: FontWeight.w500,
//                                                                   fontSize: 18
//                                                                 ),
//                                                               ),
//                                                               SizedBox(height: 20,),
//                                                               Text(
//                                                                 'Are you sure you want to unfollow this trail?', 
//                                                                 style: TextStyle(
//                                                                   color: Colors.black54,
//                                                                   fontSize: 16
//                                                                 ),
//                                                               ),
                                                         
//                                                             ],
//                                                           ),
//                                                           actions: <Widget>[
//                                                             Row(
//                                                               mainAxisAlignment: MainAxisAlignment.center,
//                                                               children: [
//                                                                 TextButton(
//                                                                   onPressed: () {
//                                                                     Navigator.of(context).pop(false); // User cancels logout
//                                                                   },
//                                                                   child: const Text('CANCEL', style: TextStyle(color: Colors.grey, fontSize: 12),),
//                                                                 ),
//                                                                 const SizedBox(width: 20,),
//                                                                 TextButton(
//                                                                   onPressed: () {
//                                                                     Navigator.of(context).pop(true); // User confirms logout
//                                                                   },
//                                                                   child: const Text('YES', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500),),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         );
//                                                       },
//                                                     );
                                                
//                                                     if (unfollowConfirmed == true) {
//                                                       bool? keepBooksConfirmed = await showDialog<bool>(
//                                                         context: context,
//                                                         builder: (BuildContext context) {
//                                                           return AlertDialog(
//                                                             backgroundColor: Colors.white,
//                                                             title: const Text(
//                                                               'Keep Books in List?',
//                                                               style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500, fontSize: 18),
//                                                             ),
//                                                             content: const Text(
//                                                               'Do you want to keep the books from this trail in your reading list?',
//                                                               style: TextStyle(color: Colors.black54, fontSize: 16),
//                                                             ),
//                                                             actions: <Widget>[
//                                                               Row(
//                                                                 mainAxisAlignment: MainAxisAlignment.center,
//                                                                 children: [
//                                                                   TextButton(
//                                                                     onPressed: () {
//                                                                       Navigator.of(context).pop(false); 
//                                                                     },
//                                                                     child: const Text('NO', style: TextStyle(color: Colors.grey, fontSize: 14)),
//                                                                   ),
//                                                                   const SizedBox(width: 20),
//                                                                   TextButton(
//                                                                     onPressed: () {
//                                                                       Navigator.of(context).pop(true);
//                                                                     },
//                                                                     child: const Text('YES', style: TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.w500)),
//                                                                   ),
//                                                                 ],
//                                                               ),
//                                                             ],
//                                                           );
//                                                         },
//                                                       );
                                                
//                                                       TrailController.unfollowTrailFromReadingList(widget.userId, trail['trail']['id'].toString(), keepBooksConfirmed!);
                                                
//                                                     }
//                                                     _loadTrails();
//                                                   },
                                                          
//                                                   child: Padding(
//                                                     padding: const EdgeInsets.only(bottom: 12.0, top: 6),
//                                                     child: Container(
//                                                       width: 200,
//                                                       height: 20,
//                                                       decoration: BoxDecoration(
//                                                         color:  Colors.grey.shade400,
//                                                         borderRadius: BorderRadius.circular(3),
//                                                         boxShadow: [
//                                                           BoxShadow(
//                                                             color: Colors.grey.shade300,
//                                                             blurRadius: 3,
//                                                             offset: const Offset(0, 2),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                       child: const Row(
//                                                         mainAxisAlignment: MainAxisAlignment.center,
//                                                         children: [
//                                                           Text(
//                                                             'Unavailable -> UNFOLLOW Trail',
//                                                             style: TextStyle(fontSize: 12, color: Colors.black87),
//                                                           ),
//                                                         ],
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                ],
//                                             ),
//                                             leading: ClipOval(
//                                               child: trail['imageUrl'] != null
//                                                   ? Image.network(
//                                                       trail['imageUrl'],
//                                                       width: 40,
//                                                       height: 40,
//                                                       fit: BoxFit.cover,
//                                                     )
//                                                   : Image.asset(
//                                                       'assets/user_profile_backgrounds_screen.png',
//                                                       width: 40,
//                                                       height: 40,
//                                                       fit: BoxFit.cover,
//                                                     ),
//                                             ),
//                                           ),
                                       
                                        
                                               
//                                       ],
//                                     ),
//                                   );
//                                 }
                  
//                                 return Card(
//                                   color: Colors.white,
//                                   margin: const EdgeInsets.only(
//                                       top: 8.0, bottom: 8.0, left: 20.0, right: 20.0),
//                                   elevation: 1,
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: ListTile(
//                                               title: Text(
//                                                 trail['title'] ?? 'No Title',
//                                                 style: const TextStyle(
//                                                   fontSize: 14,
//                                                   fontWeight: FontWeight.w500,
//                                                   color: Colors.black87,
//                                                 ),
//                                               ),
//                                               subtitle: Column(
//                                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                                 children: [
                                                  
//                                                   Text(
//                                                     trail['description'] ?? 'No description available',
//                                                     style: const TextStyle(
//                                                       color: Colors.black45,
//                                                       fontSize: 12,
//                                                     ),
//                                                     maxLines: 3, 
//                                                     overflow: TextOverflow.ellipsis,
//                                                   ),
//                                                   const SizedBox(height: 6),
//                                                   //unfollow button
//                                                   GestureDetector(
//                                                     onTap: () async {
//                                                       bool? unfollowConfirmed = await showRemoveTrailDialog(context);
                                                      
//                                                       if (unfollowConfirmed == true) {
                                                        
//                                                         bool? keepBooks = await showKeepBooksDialog(context);

//                                                         await TrailController.unfollowTrailFromReadingList(widget.userId, trail['trail']['id'].toString(), keepBooks!);
                  
//                                                       }
//                                                        _loadTrails();
//                                                     },
                                      
//                                                     child: Padding(
//                                                       padding: const EdgeInsets.only(bottom: 12.0, top: 6),
//                                                       child: Container(
//                                                         width: 80,
//                                                         height: 20,
//                                                         decoration: BoxDecoration(
//                                                           color: const Color(0xFFFFDCAA),
//                                                           borderRadius: BorderRadius.circular(3),
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey.shade300,
//                                                               blurRadius: 3,
//                                                               offset: const Offset(0, 2),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: const Row(
//                                                           mainAxisAlignment: MainAxisAlignment.center,
//                                                           children: [
//                                                             Text(
//                                                               'UNFOLLOW',
//                                                               style: TextStyle(fontSize: 12, color: Colors.black87),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                              leading: trail['imageUrl'] != null
//                                               ? ClipOval(
//                                                   child: CachedNetworkImage(
//                                                     imageUrl: trail['imageUrl'],
//                                                     width: 50,
//                                                     height: 50,
//                                                     fit: BoxFit.cover,
//                                                   ),
//                                                 )
//                                               : const Icon(Icons.book, size: 50),
                  
//                                             ),
//                                           ),
//                                         ],
//                                       ),
                                          
//                                       ],
//                                   ),
//                                 );
//                               },
//                             ),
//                     ],
//                   ),
//               const SizedBox(height: 60),
              
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }