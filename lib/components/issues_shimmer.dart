import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class IssuesWithShimmer extends StatelessWidget {
  const IssuesWithShimmer({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(physics: const NeverScrollableScrollPhysics(), shrinkWrap: true, itemCount: 10, itemBuilder: ((context, index) => const ShimmerIssue()));
  }
}


// single issue with the shimmer effect
class ShimmerIssue extends StatelessWidget {
  const ShimmerIssue({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: const Card(child: ListTile(title: Text(''), subtitle: Text(''),),),
    );
  }
}