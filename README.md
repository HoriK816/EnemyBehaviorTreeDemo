# Abstract
 This is a repository to demonstrate the enemy's character AI at the 2D shooting game. My 
enemy character AI is implemented by BT(Behavior Tree) which is often used to 
create behaviors of robotics or NPC (Non-Playable Character)  in game developing context.
 And then, not only the character AI, I implements entire this demo with Processing. 
Processing is a programming environment for visual programming. And, you can very 
easy to test it with Processing.

# How to use 
![how to use](/imgs/screenshots/how_to_use.png)
1. Open any program file with Processing. (You can open all program, if you 
open any file with double-click)
2. Run the demo program by Start button. Start button is in upper right of the 
window.
3. New window is be opened and Demo starts.

I confirmed this program works correctly in version 4.3.4 of processing.

# About BT (Behavior Tree)
 Behavior Tree, it's often abbreviated to BT, is a algorithm to create 
behaviors of NPC (Non-Playable Character). BT is often used even in commercial
games, and Final Fantasy(FF) series is one of the most famous examples ( 
Strictly speaking, it's not only BT that the character AI algorithm used in
FF series is...) 
 In this BT, character's behavior is presented by Tree structure. We build the 
the tree with BT nodes, then There are mainly three types of nodes.

They are
 * Control Nodes
 * Leaf Nodes
 * Decorator Nodes

 Control Nodes are nodes that control the process flow. For example, Sequence 
Node, a type of control nodes, execute all child nodes sequentially.

 Leaf Nodes are nodes that corresponded to actual character's behavior. All 
Characters do ACTION and MAKE A DECISIONS in the game world. Leaf Nodes 
correspond to them.

 Decorator Nodes are node to alter operation of the specific nodes. For example,
Repeater Nodes execute the child node repeatedly, and Inverter Nodes invert 
results of the child node.

 Furthermore, All BT nodes returns the threes types of result. 

 They are
 * SUCCESS 
 * FAILURE
 * RUNNING

 SUCCESS represents that the node finish their work correctly. FAILURE is opposite
,vice verse. RUNNING represents that the node still executing status. Normally,
Character's Action (walk, attack, chanting a spell and so on...) takes time, therefore
the corresponding node continue to return RUNNING during the time.

 It's possible to decide next action of the character by tracing the tree 
regularly. By the way, My demo program trace the tree every draw calls(this function in 
processing a kind of update in other programming platform).

# Structure of My Enemy AI 
![object tree for BT](/imgs/figures/object_tree_bt.png)
This image represents Object Tree for BT in this project. Although I don't implements 
all types of node in BT, it seems to sufficient to create various enemy action
patterns in 2D shooting games.

As mentioned previously, ActionNode and ConditionNode are correspond to actual 
enemy's actions and making decisions. Then, We have to inherit them to create 
each action and making decisions.

There are SequenceNode and SelectorNode as ControlNode.

In addition, I implemented InverterNode, RepeaterNode, KeepRunningUntilFailureNode
and RetryUntilSuccessfulNode as DecoratorNode.

I built enemy's behavior tree with these tree components.

![my enemy AI](/imgs/figures/my_enemy_ai_structure.png)
This is the structure of my enemy character AI. It has a lot of nodes, but it's
not very complicated.

Roughly speaking, The Enemy's behavior is like this. 
* The distance to player is less than L -> close to player and make an melee attack
* The distance to player is greater than or equal L -> random move or make an ranged attack 
    * There are three types of ranged shot 
        * Normal shot
        * Bullet Hell 1 (All range shot + N-way)
        * Bullet Hell 2 (rapid firing)

![my enemy AI](/imgs/figures/my_enemy_ai_structure_with_indicator.png)
By the way, you might become unable to recognize what you are create.
It's difficult to build complicated behaviors because my program doesn't provide
DSL(Domain Specific Language) to build a tree. As a countermeasure for it, 
It works the way that give an indicator each node such as alphabet for me.

# Reference
I refered the web site below about Behavior Tree.

[behaviortree.dev](https://www.behaviortree.dev/docs/Intro)
