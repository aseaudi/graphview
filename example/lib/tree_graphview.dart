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

    builder
      ..siblingSeparation = (100)
      ..levelSeparation = (150)
      ..subtreeSeparation = (150)
      ..orientation = (BuchheimWalkerConfiguration.ORIENTATION_TOP_BOTTOM);
  }
}
