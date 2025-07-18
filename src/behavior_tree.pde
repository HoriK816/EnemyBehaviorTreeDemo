enum NodeStatus{
    SUCCESS, FAILURE, RUNNING;
}


class BehaviorTreeNode{
    String name;
    NodeStatus status;

    BehaviorTreeNode(String nodeName) {
        this.name = nodeName;
    }

    /* must override this method */
    NodeStatus evalNode() {
        return null;
    }

    /* debug function */
    void printName() {
        println("the name of this node is ", name); 
    }
}


class ControlNode extends BehaviorTreeNode{
    ArrayList<BehaviorTreeNode> children;

    ControlNode(String nodeName) {
        super(nodeName);
        this.children = new ArrayList<BehaviorTreeNode>();
    }

    void addChild(BehaviorTreeNode new_node) {
        children.add(new_node);  
    }

    void printAllChildren() {
        int len = children.size();

        for (int i=0; i<len; i++) {
            children.get(i).printName();
        }
    }
}


class SequenceNode extends ControlNode {
    int numberChildren         = 0;
    int numberExecutedChildren = 0;

    SequenceNode(String nodeName) {
        super(nodeName);
    }

    NodeStatus executeAllChildren() {
        BehaviorTreeNode processNode;
        NodeStatus sequenceStatus = null;
        NodeStatus processResult;

        numberChildren = this.children.size();
        if (numberExecutedChildren == numberChildren) {
            return NodeStatus.SUCCESS;
        }

        // check the child node currently being processed
        processNode = children.get(numberExecutedChildren);

        // decide sequence status depend on the result of the current node.
        processResult = processNode.evalNode();
        switch (processResult) {
            case SUCCESS:
                numberExecutedChildren++;
                sequenceStatus = NodeStatus.RUNNING;
                break;
            case FAILURE:
                  numberExecutedChildren++;
                  sequenceStatus = NodeStatus.RUNNING;
                  break;
            case RUNNING:
                  sequenceStatus = NodeStatus.RUNNING;
                  break;
        }
        return sequenceStatus;
    }

    @Override
    NodeStatus evalNode() {
        NodeStatus result;
        result = this.executeAllChildren();
        return result;
    }
}


class SelectorNode extends ControlNode {
    int number_children = 0;
    int number_executed = 0;

    SelectorNode (String nodeName) {
        super(nodeName);
    }

    NodeStatus executeChildren() {
        BehaviorTreeNode process_node;
        NodeStatus selector_status = null;
        NodeStatus node_result;

        number_children = this.children.size();

        if (number_executed == number_children) {
            // reaching the final node means that no node returns SUCCESS
            selector_status = NodeStatus.FAILURE;
            return NodeStatus.FAILURE;

        } else {

            process_node = children.get(number_executed);
            node_result = process_node.evalNode();

            switch (node_result) {
                case SUCCESS:
                    selector_status = NodeStatus.SUCCESS;
                    break;
                case FAILURE:
                    number_executed++;
                    selector_status = NodeStatus.RUNNING;
                    break;
                case RUNNING:
                    selector_status = NodeStatus.RUNNING;
                    break;
            }
        }
        return selector_status;
    }

    @Override
    NodeStatus evalNode() {
        NodeStatus result;
        result = executeChildren();
        return result;
    }

}

/* This is a base class for decorator nodes. */
class DecoratorNode extends BehaviorTreeNode {
    BehaviorTreeNode child;

    DecoratorNode(String nodeName) {
        super(nodeName);
    }

    void setChild(BehaviorTreeNode new_node) {
        this.child = new_node;
    }
}


/* InverterNode is a node to invert the result of child node and return it */
class InverterNode extends DecoratorNode {

    InverterNode(String nodeName) {
        super(nodeName);
    }

    @Override
    NodeStatus evalNode() {
        NodeStatus result;
        result = child.evalNode();

        switch(result) {
          case SUCCESS:
            result = NodeStatus.FAILURE; 
            break;
          case FAILURE:
            result = NodeStatus.SUCCESS;
            break;
          case RUNNING:
            result = NodeStatus.RUNNING;
            break;
        }
        return result;
    }
}


/* RepeaterNode is a node to execute the specific child node repeatedly */
class RepeaterNode extends DecoratorNode {
    int repeatCount = 0;

    RepeaterNode(String nodeName, int repeatCount) {
        super(nodeName);
        this.repeatCount = repeatCount;
    }

    @Override
    NodeStatus evalNode() {
        NodeStatus result = child.evalNode();

        // it's termination condition of this node.
        if (repeatCount == 0) {
            return NodeStatus.SUCCESS;
        }

        switch (result) {
            case SUCCESS:
                result = NodeStatus.RUNNING;
                repeatCount--;
                break;
            case FAILURE:
                result = NodeStatus.FAILURE;
                break;
            case RUNNING:
                result = NodeStatus.RUNNING;
                break;
        }
        return result;
    }
}


class RetryUntilSuccessfulNode extends DecoratorNode {
    int number_attempt;

    RetryUntilSuccessfulNode(String nodeName, int number_attempt) {
        super(nodeName);
        this.number_attempt =  number_attempt; 
    }

    @Override 
    NodeStatus evalNode() {
        NodeStatus result;

        result = child.evalNode();
        switch (result) {
            case SUCCESS:
                result = NodeStatus.SUCCESS;
                break;
            case FAILURE:
                result = NodeStatus.RUNNING;
                number_attempt--;
                break;
            case RUNNING:
                result = NodeStatus.RUNNING;
                break;
        }

        if (number_attempt == 0) {
            result = NodeStatus.FAILURE;
        }
        return result;
    }
}


class KeepRunningUntilFailureNode extends DecoratorNode{

    KeepRunningUntilFailureNode(String nodeName) {
        super(nodeName);
    }

    @Override
    NodeStatus evalNode() {
        NodeStatus result;

        result = child.evalNode();
        switch (result) {
          case SUCCESS:
            result = NodeStatus.RUNNING;
            break;
          case FAILURE:
            result = NodeStatus.FAILURE;
            break;
          case RUNNING:
            result = NodeStatus.RUNNING;
            break;
        }
        return result;
    }
}

/* This is a base class for leaf nodes. */
class LeafNode extends BehaviorTreeNode{ 
    NodeStatus status;

    LeafNode(String nodeName){
        super(nodeName);
    }
}


class ConditionNode extends LeafNode{
    boolean is_met = false;
    NodeStatus status;

    ConditionNode(String nodeName){
        super(nodeName);
    }

    /*
        NOTE: It's better that checkCondition() returns boolean value
        depend on the condition...
    */
    void checkCondition(){
        if(is_met){
            status =  NodeStatus.SUCCESS;
        }else{
            status =  NodeStatus.FAILURE;
        }
    }

    @Override
    NodeStatus evalNode(){
        checkCondition();
        return this.status; 
    }
}

class ActionNode extends LeafNode{
    boolean isFinished      = false;
    boolean enableRepeat    = false;  // by default, repeating is disabled. 
    int requiredTotalFrames = 0;
    int remainedFrames      = 0;      // it's decremented every Action() calls

    ActionNode(String nodeName, int requiredTotalFrames){
        super(nodeName);
        this.requiredTotalFrames = requiredTotalFrames;
        this.remainedFrames      = requiredTotalFrames;
    }

    NodeStatus Action(){
        if(0 < remainedFrames){
            remainedFrames--;
            return NodeStatus.RUNNING;

        /* execute process to finite the action if remaindFrames reaches 0 */
        }else{

            /* reset */
            if(enableRepeat){
                isFinished = false;
                remainedFrames = requiredTotalFrames;
            }
            return NodeStatus.SUCCESS;
        }
    }

    @Override 
    NodeStatus evalNode(){
        NodeStatus result;
        result = this.Action();
        return result;
    }
}
