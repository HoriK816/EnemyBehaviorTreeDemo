<img src="/imgs/screenshots/game_scene.gif" width="150%">

# Abstract
This is a repository to demonstrate the enemy's character AI in the 2D shooting 
game. My enemy character AI is implemented using BT (Behavior Tree), which is 
often used to create behaviors for robotics or NPCs (Non-Playable Characters) 
in game development contexts. 

And then, not only the character AI, I implement the entire Demo with Processing. 
Processing is a programming environment for visual programming. And, you can 
test it easily with Processing.

# How to use 
![how to use](/imgs/screenshots/how_to_use.png)
1. Open any program file with Processing by double-clicking it. 
(Opening one file will open all programs.)
2. Run the demo program with the Start button. The start button is in 
the upper right of the window.
3. A new window will open, and the Demo will start. 

I confirmed this program works correctly in version 4.3.4 of processing.

# How to Control
* UP Arrow Key    : move up
* Down Arrow Key  : move down
* Right Array Key : move right
* Left Array Key  : move left
* Z key           : ranged attack 
* X key           : melee attack

# About BT (Behavior Tree)
Behavior Tree, often abbreviated to BT, is an algorithm to create behaviors of 
NPC (Non-Playable Character). BT is often used even in commercial games, and 
the FF (Final Fantasy) series is one of the most famous examples (Strictly 
speaking, the character AI algorithm used in the FF series is not limited to 
BT...). In this BT, the character's behavior is presented by a tree structure. 
We use BT nodes to build the tree, and there are mainly three types of nodes. 

They are
* Control Nodes
* Leaf Nodes
* Decorator Nodes

Control Nodes are nodes that control the process flow. For example, Sequence 
Node, a type of control node, executes all child nodes sequentially.

Leaf Nodes are nodes that correspond to the actual character's behavior. 
All Characters do ACTION and MAKE DECISIONS in the game world. Leaf Nodes 
correspond to them.

Decorator Nodes are nodes that alter operations at the specific nodes. 
For example, Repeater Nodes execute the child node repeatedly, and 
Inverter Nodes invert the results of the child node.

Furthermore, all BT nodes return the three types of results.

They are
* SUCCESS
* FAILURE
* RUNNING

SUCCESS represents that the node finishes its work correctly. FAILURE is vice 
versa. RUNNING represents that the node is still in an 
executing state. Normally, the Character's Action (walking, attacking, chanting 
a spell, and so on...) takes time, therefore the corresponding node continues 
to return to RUNNING during that time.

It's possible to decide the next action of the character by tracing the tree 
regularly. By the way, my demo program traces the tree every draw call (this 
function in processing a kind of update in other programming platforms).


# Structure of My Enemy AI 
![object tree for BT](/imgs/figures/object_tree_bt.png)
This image represents the Object Tree for BT in this project. Although I don't 
implement all types of nodes in BT, it seems to be sufficient to create various 
enemy action patterns in 2D shooting games.

As mentioned previously, ActionNode and ConditionNode correspond to the actual 
enemy's actions and decisions. Then, we have to inherit them to create each 
action and make decisions.

There are SequenceNode and SelectorNode as ControlNode.

In addition, I implemented InverterNode, RepeaterNode, 
KeepRunningUntilFailureNode, and RetryUntilSuccessfulNode as DecoratorNode.

![my enemy AI](/imgs/figures/my_enemy_ai_structure.png)
built an enemy's behavior tree with these three components.
This is the structure of my enemy character AI. It has a lot of nodes, but 
it's not very complicated.

Roughly speaking, the enemy's behavior is like this.
* The distance to the player is less than L -> close to the player and make a melee attack
* The distance to the player is greater than or equal to L -> random move or make a ranged attack
	* There are three types of ranged shot
		* Normal shot
		* Bullet Hell 1 (All range shot + N-way)
		* Bullet Hell 2 (rapid firing)

![my enemy AI](/imgs/figures/my_enemy_ai_structure_with_indicator.png)
By the way, you might find it hard to recognize what you are creating. It's 
difficult to build complicated behaviors because my program doesn't provide 
DSL(Domain Specific Language) to build a tree. As a countermeasure for it, 
It works the way that gives an indicator for each node such as the alphabet for 
me.

# Reference
I used the website below as a reference.

[behaviortree.dev](https://www.behaviortree.dev/docs/Intro)
