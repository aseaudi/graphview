import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';

class TreeViewPage extends StatefulWidget {
  @override
  _TreeViewPageState createState() => _TreeViewPageState();
}

class _TreeViewPageState extends State<TreeViewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        // body: Column(
        //   mainAxisSize: MainAxisSize.max,
        //   children: [
        //     Wrap(
        //       children: [
        //         Container(
        //           width: 100,
        //           child: TextFormField(
        //             initialValue: builder.siblingSeparation.toString(),
        //             decoration: InputDecoration(labelText: 'Sibling Separation'),
        //             onChanged: (text) {
        //               builder.siblingSeparation = int.tryParse(text) ?? 100;
        //               this.setState(() {});
        //             },
        //           ),
        //         ),
        //         Container(
        //           width: 100,
        //           child: TextFormField(
        //             initialValue: builder.levelSeparation.toString(),
        //             decoration: InputDecoration(labelText: 'Level Separation'),
        //             onChanged: (text) {
        //               builder.levelSeparation = int.tryParse(text) ?? 100;
        //               this.setState(() {});
        //             },
        //           ),
        //         ),
        //         Container(
        //           width: 100,
        //           child: TextFormField(
        //             initialValue: builder.subtreeSeparation.toString(),
        //             decoration: InputDecoration(labelText: 'Subtree separation'),
        //             onChanged: (text) {
        //               builder.subtreeSeparation = int.tryParse(text) ?? 100;
        //               this.setState(() {});
        //             },
        //           ),
        //         ),
        //         Container(
        //           width: 100,
        //           child: TextFormField(
        //             initialValue: builder.orientation.toString(),
        //             decoration: InputDecoration(labelText: 'Orientation'),
        //             onChanged: (text) {
        //               builder.orientation = int.tryParse(text) ?? 100;
        //               this.setState(() {});
        //             },
        //           ),
        //         ),
        //         ElevatedButton(
        //           onPressed: () {
        //             final node12 = Node.Id(r.nextInt(100));
        //             var edge = graph.getNodeAtPosition(r.nextInt(graph.nodeCount()));
        //             print(edge);
        //             graph.addEdge(edge, node12);
        //             setState(() {});
        //           },
        //           child: Text('Add'),
        //         )
        //       ],
        //     ),
            // Expanded(
              body: InteractiveViewer(
                  constrained: false,
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.01,
                  maxScale: 5.6,
                  child: GraphView(
                    graph: graph,
                    algorithm: BuchheimWalkerAlgorithm(builder, TreeEdgeRenderer(builder)),
                    paint: Paint()
                      ..color = Colors.green
                      ..strokeWidth = 1
                      ..style = PaintingStyle.stroke,
                    builder: (Node node) {
                      // I can decide what widget should be shown here based on the id
                      var a = node.key!.value as int?;
                      return rectangleWidget(a);
                    },
                  )
                ),
            // ),
          // ],
        // )
        );
  }

  Random r = Random();

  createUncle(int a) {
    var clicked_node = graph.getNodeAtPosition(a!-1);
        var clicked_node_parent_id = clicked_node.getParentId;
        print('clicked Node parent: ${clicked_node_parent_id}');
        var clicked_node_parent_node = graph.getNodeAtPosition(clicked_node_parent_id-1);
        Node uncle_node = Node.Id(graph.nodeCount() + 1);
        uncle_node.setDescription = 'Uncle';
        uncle_node.setParentId = clicked_node_parent_id;
        Node cousin1_node = Node.Id(graph.nodeCount() + 2);
        cousin1_node.setDescription = 'Cousin';
        cousin1_node.setParentId = graph.nodeCount() + 1;
        Node cousin2_node = Node.Id(graph.nodeCount() + 3);
        cousin2_node.setDescription = 'Cousin';
        cousin2_node.setParentId = graph.nodeCount() + 1;
        Node son1_node = Node.Id(graph.nodeCount() + 4);
        son1_node.setDescription = 'Son';
        son1_node.setParentId = graph.nodeCount() + 2;
        Node daughter1_node = Node.Id(graph.nodeCount() + 5);
        daughter1_node.setDescription = 'Daugther';
        daughter1_node.setParentId = graph.nodeCount() + 2;
        Node son2_node = Node.Id(graph.nodeCount() + 6);
        son2_node.setDescription = 'Son';
        son2_node.setParentId = graph.nodeCount() + 3;
        Node daughter2_node = Node.Id(graph.nodeCount() + 7);
        daughter2_node.setDescription = 'Daughter';
        daughter2_node.setParentId = graph.nodeCount() + 3;
        print(clicked_node);
        graph.addEdge(clicked_node_parent_node, uncle_node);
        graph.addEdge(uncle_node, cousin1_node);
        graph.addEdge(uncle_node, cousin2_node);
        graph.addEdge(cousin1_node, son1_node);
        graph.addEdge(cousin1_node, daughter1_node);
        graph.addEdge(cousin2_node, son2_node);
        graph.addEdge(cousin2_node, daughter2_node);
        setState(() {});
  }

  Widget rectangleWidget(int? a) {
    return InkWell(
      onTap: () {
        print('clicked Node: ${a}');
        createUncle(a!);
      },
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
            ],
          ),
          child: Text('Node ${a}, ${graph.getNodeAtPosition(a!-1).getDescription}')),
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {

    Node root_node = Node.Id(0);
    root_node.setDescription = 'Root';
    print(root_node.getDescription);
    Node node1 = Node.Id(1);
    node1.setDescription = 'Grandfather';
    node1.setParentId = 0;
    print(node1.getDescription);
    Node node2 = Node.Id(2);
    node2.setDescription = 'Father';
    node2.setParentId = 1;
    print(node2.getDescription);
    Node node3 = Node.Id(3);
    node3.setDescription = 'Uncle';
    node3.setParentId = 1;
    print(node3.getDescription);
    Node node4 = Node.Id(4);
    node4.setDescription = 'Me';
    node4.setParentId = 2;
    print(node4.getDescription);
    Node node5 = Node.Id(5);
    node5.setDescription = 'Son';
    node5.setParentId = 4;
    print(node5.getDescription);
    Node node6 = Node.Id(6);
    node6.setDescription = 'Daughter';
    node6.setParentId = 4;
    print(node6.getDescription);
    Node node7 = Node.Id(7);
    node7.setDescription = 'Cousin';
    node7.setParentId = 3;
    print(node7.getDescription);
    Node node8 = Node.Id(8);
    node8.setDescription = 'Cousin';
    node8.setParentId = 3;
    print(node8.getDescription);
    Node node9 = Node.Id(9);
    node9.setDescription = 'Son';
    node9.setParentId = 7;
    print(node9.getDescription);
    Node node10 = Node.Id(10);
    node10.setDescription = 'Daughter';
    node10.setParentId = 7;
    print(node10.getDescription);
    Node node11 = Node.Id(11);
    node11.setDescription = 'Son';
    node11.setParentId = 8;
    print(node11.getDescription);
    Node node12 = Node.Id(12);
    node12.setDescription = 'Daughter';
    node12.setParentId = 8;
    print(node12.getDescription);
    // final node4 = Node.Id(4);
    // final node5 = Node.Id(5);
    // final node6 = Node.Id(6);
    // final node7 = Node.Id(7);
    // final node8 = Node.Id(8);
    // final node9 = Node.Id(9);
    // final node10 = Node.Id(10);
    // final node11 = Node.Id(11);
    // final node12 = Node.Id(12);
    graph.addEdge(node1, node2);
    graph.addEdge(node1, node3);
    graph.addEdge(node2, node4);
    graph.addEdge(node4, node5);
    graph.addEdge(node4, node6);
    graph.addEdge(node3, node7);
    graph.addEdge(node3, node8);
    graph.addEdge(node7, node9);
    graph.addEdge(node7, node10);
    graph.addEdge(node8, node11);
    graph.addEdge(node8, node12);
    //graph.addEdge(node1, node3, paint: Paint()..color = Colors.red);
    // graph.addEdge(node1, node4, paint: Paint()..color = Colors.blue);
    // graph.addEdge(node2, node5);
    // graph.addEdge(node2, node6);
    // graph.addEdge(node6, node7, paint: Paint()..color = Colors.red);
    // graph.addEdge(node6, node8, paint: Paint()..color = Colors.red);
    // graph.addEdge(node4, node9);
    // graph.addEdge(node4, node10, paint: Paint()..color = Colors.black);
    // graph.addEdge(node4, node11, paint: Paint()..color = Colors.red);
    // graph.addEdge(node11, node12);

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }
}
