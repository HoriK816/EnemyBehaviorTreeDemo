class Enemy extends Character{
    int   maxSpeed    = 10;
    color enemy_color = color(255, 255, 0);     // purple 
    ControlNode root;

    Enemy (float x, float y) {
        super(x, y);

        /* Create a root node of behavior tree */
        root = new SequenceNode("root");
    }

    void takeAction() {
        NodeStatus root_status = root.evalNode();

        /* Rebuild behavior tree  */
        if (root_status != NodeStatus.RUNNING){
            this.root = new SequenceNode("root");
            createBehaviorTree();
        }
    }

    void createBehaviorTree(){
        RandomNumberStack r_stack = new RandomNumberStack();

        /* Melee  */ 
        SelectorNode     b = new SelectorNode("b");
        InverterNode     c = new InverterNode("c");
        IsShortRange     d = new IsShortRange(300, player, enemy);
        SequenceNode     e = new SequenceNode("e");
        CloseToPlayer    f = new CloseToPlayer("close to player", 30, enemy, player);
        EnemyMeleeAttack g = new EnemyMeleeAttack("melee", 10, enemy, enemySword);
        c.setChild(d);
        e.addChild(f);
        e.addChild(g);
        b.addChild(c);
        b.addChild(e);

        root.addChild(b); 

        /* Move or Shot  */
        SelectorNode    h = new SelectorNode("h");
        IsShortRange    i = new IsShortRange(300, player, enemy);
        h.addChild(i);

        SequenceNode    j = new SequenceNode("j"); 
        RandomGenerator k = new RandomGenerator(r_stack);
        j.addChild(k);

        /* Move  */
        SelectorNode                l = new SelectorNode("l");   
        InverterNode                m = new InverterNode("m");    
        IsRandomNumberOverThreshold n = new IsRandomNumberOverThreshold(70, r_stack);
        SequenceNode                o = new SequenceNode("o");
        RandomEnemyWalk             p = new RandomEnemyWalk("p", 300, enemy);
        m.setChild(n);
        o.addChild(p);
        l.addChild(m);
        l.addChild(o);
        j.addChild(l);

        SelectorNode                 q = new SelectorNode("q");
        IsRandomNumberOverThreshold rs = new IsRandomNumberOverThreshold(70, r_stack);
        q.addChild(rs);
        j.addChild(q);

        SequenceNode t = new SequenceNode("t");

        RandomGenerator u = new RandomGenerator(r_stack);
        t.addChild(u);

        /* danmaku 1  */
        SelectorNode                  w = new SelectorNode("w");
        InverterNode                  x = new InverterNode("x");
        IsRandomNumberOverThreshold   y = new IsRandomNumberOverThreshold(70, r_stack);

        x.setChild(y);

        SequenceNode                  z = new SequenceNode("z");
        RepeaterNode                 aa = new RepeaterNode("aa", 2);    
        SequenceNode                 ab = new SequenceNode("ab");
        EnemyAllRangeShot            ac = new EnemyAllRangeShot("ac", 10, enemy);
        RepeaterNode                 ad = new RepeaterNode("aa", 3);    
        EnemyNWayShot                ae = new EnemyNWayShot("enemy nway", 20, enemy, player);

        ad.setChild(ae);
        ab.addChild(ac);
        ab.addChild(ad);
        aa.setChild(ab);
        z.addChild(aa);

        w.addChild(x);
        w.addChild(z);
        t.addChild(w);

        /* danamku 2  */
        SelectorNode                 af = new SelectorNode("af"); 
        InverterNode                 ag = new InverterNode("ag");
        IsRandomNumberBetweenAandB   ah = new IsRandomNumberBetweenAandB(65, 70, r_stack);
        SequenceNode                 ai = new SequenceNode("aj");
        RepeaterNode                 aj = new RepeaterNode("aj", 100);
        EnemyRangeAttack             ak = new EnemyRangeAttack("ak", 1, enemy, player);

        ag.setChild(ah);
        aj.setChild(ak);
        ai.addChild(aj);

        af.addChild(ag);
        af.addChild(ai);
        t.addChild(af);

        /* Normal shot  */
        SelectorNode                 al = new SelectorNode("al");
        IsRandomNumberOverThreshold amn = new IsRandomNumberOverThreshold(65, r_stack);
        SequenceNode                 ao = new SequenceNode("ao");
        EnemyRangeAttack             ap  = new EnemyRangeAttack("ap", 10, enemy, player);

        ao.addChild(ap);
        al.addChild(amn);
        al.addChild(ao);
        t.addChild(al);

        ReleaseRandomStackTop bb = new ReleaseRandomStackTop(r_stack);
        t.addChild(bb);

        q.addChild(t);

        ReleaseRandomStackTop ba = new ReleaseRandomStackTop(r_stack);
        j.addChild(ba);
        h.addChild(j);

        root.addChild(h);
    }

    void move(Direction direction, int speed) {
        switch (direction) {
            case UP:
                position.y -= speed;
                break;
            case LEFT:
                position.x -= speed;
                break;
            case RIGHT:
                position.x += speed;
                break;
            case DOWN:
                position.y += speed;
                break;
        }
    }

    @Override
    public void draw() {
        fill(enemy_color);
        super.draw();
    }

    public void all_range_shot(ArrayList<Bullet> bullets) {
        int ways = 50;
        for(float d=0; d<2*PI; d+=2*PI/ways) {
            Bullet bullet = new Bullet(position.x, position.y, 5, d);
            bullets.add(bullet);
        }
    }

    public void normal_shot(ArrayList<Bullet> bullets) {
        int bullet_speed = 10;
        float direction = 0;
        Bullet bullet = new Bullet(position.x + (width/2), position.y + height,
                                   bullet_speed, direction);
        bullets.add(bullet);
    }

    public void aim_shot(ArrayList<Bullet> bullets, Player player) {
        PVector target = player.position;
        int target_width = player.width;
        int target_height = player.height;

        float theta = atan2(target.y + target_width/2 - position.y - height,
                            target.x + target_height/2 - position.x - width/2);

        Bullet bullet = new Bullet(position.x + (width/2),
                                   position.y + (height),
                                   5, theta-HALF_PI);
        bullets.add(bullet);
    }

    public void random_spread_shot(ArrayList<Bullet> bullets) {
            int number_of_bullets = 5;
            for (int i =0; i < number_of_bullets; i++) {

                    float random_direction = random(-(HALF_PI/2), HALF_PI/2);

                    Bullet bullet = new Bullet(position.x + width/2,
                                               position.y + height,
                                               5, random_direction);
                    bullets.add(bullet);
            }

    }

    public void nway_shot(ArrayList<Bullet> bullets, Player player) {
            float ways = 5;
            float shot_degree = HALF_PI;
            PVector target = player.position;
            int target_width = player.width;
            int target_height = player.height;

            float pivot = atan2(target.y + target_width/2 - position.y - width/2,
                                target.x + target_height/2 - position.x - height) 
                                - HALF_PI;
 

            // pivot 
            Bullet bullet = new Bullet(position.x + width/2,
                                       position.y + height, 5, pivot);
            bullets.add(bullet);


            // clockwise direction
            float degree = pivot; 
            for (float i=1; i<ways/2; i++) {
                    degree -=  shot_degree/ways;
                    bullet = new Bullet(position.x + width/2,
                                        position.y + height, 5, degree);
                    bullets.add(bullet);
            }

            // counterclockwise direction
            degree = pivot; 
            for (float i=1; i<ways/2; i++) {
                    degree += shot_degree/ways;
                    bullet = new Bullet(position.x + width/2,
                                        position.y + height, 5, degree);
                    bullets.add(bullet);
            }
    }


    public void melleAttack(Sword sword) {
        if (!sword.isActive) {
            sword.activate();
        }
    }

}
