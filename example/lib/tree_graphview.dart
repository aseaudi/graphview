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

  createCousin(int uncle_node_id) {
        int nodeCount = graph.nodeCount();

        Node uncle_node = graph.getNodeAtPosition(uncle_node_id-1);

        Node cousin_node = Node.Id(nodeCount + 1);
        cousin_node.setDescription = 'Cousin';
        cousin_node.setParentId = uncle_node.key?.value;
        graph.addEdge(uncle_node, cousin_node);

        Node son_node = Node.Id(nodeCount + 2);
        son_node.setDescription = 'Son';
        son_node.setParentId = cousin_node.key?.value;
        graph.addEdge(cousin_node, son_node);

        Node daughter_node = Node.Id(nodeCount + 3);
        daughter_node.setDescription = 'Daugther';
        daughter_node.setParentId = cousin_node.key?.value;
        graph.addEdge(cousin_node, daughter_node);

        setState(() {});
  }

  createUncle() {
        int nodeCount = graph.nodeCount();

        Node grandfather_node = graph.getNodeAtPosition(0);

        Node uncle_node = Node.Id(nodeCount + 1);
        uncle_node.setDescription = 'Uncle';
        uncle_node.setParentId = 1;
        graph.addEdge(grandfather_node, uncle_node);

        createCousin(nodeCount + 1);
        createCousin(nodeCount + 1);

        setState(() {});
  }

  Widget rectangleWidget(int? a) {
    return InkWell(
      onTap: () {
        print('clicked Node: ${a}');
        if (graph.getNodeAtPosition(a!-1).getDescription == 'Uncle') createUncle();
        else if (graph.getNodeAtPosition(a!-1).getDescription == 'Cousin') createCousin(graph.getNodeAtPosition(a!-1).getParentId);
      },
      child: Row(        
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
              ],
            ),
            child: Text('Node ${a}, ${graph.getNodeAtPosition(a!-1).getDescription}')
          ),
          SizedBox(
            width: 10
          ),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              boxShadow: [
                BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
              ],
            ),
            child: Text('Wife')
          )
        ],
      ),
    );
  }

  final Graph graph = Graph()..isTree = true;
  BuchheimWalkerConfiguration builder = BuchheimWalkerConfiguration();

  @override
  void initState() {

    Node root_node = Node.Id(0);
    root_node.setDescription = 'Root';
    print(root_node.getDescription);

    Node grandfather_node = Node.Id(1);
    grandfather_node.setDescription = 'Grandfather';
    grandfather_node.setParentId = 0;

    Node father_node = Node.Id(2);
    father_node.setDescription = 'Father';
    father_node.setParentId = 1;
    graph.addEdge(grandfather_node, father_node);

    Node me_node = Node.Id(3);
    me_node.setDescription = 'Me';
    me_node.setParentId = 2;
    print(me_node.getDescription);
    graph.addEdge(father_node, me_node);

    Node son_node = Node.Id(4);
    son_node.setDescription = 'Son';
    son_node.setParentId = 3;
    print(son_node.getDescription);
    graph.addEdge(me_node, son_node);
    
    Node daughter_node = Node.Id(5);
    daughter_node.setDescription = 'Daughter';
    daughter_node.setParentId = 3;
    print(daughter_node.getDescription);
    graph.addEdge(me_node, daughter_node);

    createUncle();

    // Node node3 = Node.Id(3);
    // node3.setDescription = 'Uncle';
    // node3.setParentId = 1;
    // print(node3.getDescription);

    // Node node7 = Node.Id(7);
    // node7.setDescription = 'Cousin';
    // node7.setParentId = 3;
    // print(node7.getDescription);
    // Node node8 = Node.Id(8);
    // node8.setDescription = 'Cousin';
    // node8.setParentId = 3;
    // print(node8.getDescription);
    // Node node9 = Node.Id(9);
    // node9.setDescription = 'Son';
    // node9.setParentId = 7;
    // print(node9.getDescription);
    // Node node10 = Node.Id(10);
    // node10.setDescription = 'Daughter';
    // node10.setParentId = 7;
    // print(node10.getDescription);
    // Node node11 = Node.Id(11);
    // node11.setDescription = 'Son';
    // node11.setParentId = 8;
    // print(node11.getDescription);
    // Node node12 = Node.Id(12);
    // node12.setDescription = 'Daughter';
    // node12.setParentId = 8;
    // print(node12.getDescription);
    
    // graph.addEdge(node1, node3);
    

    // graph.addEdge(node3, node7);
    // graph.addEdge(node3, node8);
    // graph.addEdge(node7, node9);
    // graph.addEdge(node7, node10);
    // graph.addEdge(node8, node11);
    // graph.addEdge(node8, node12);
//createUncle();

    // final node4 = Node.Id(4);
    // final node5 = Node.Id(5);
    // final node6 = Node.Id(6);
    // final node7 = Node.Id(7);
    // final node8 = Node.Id(8);
    // final node9 = Node.Id(9);
    // final node10 = Node.Id(10);
    // final node11 = Node.Id(11);
    // final node12 = Node.Id(12);
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
