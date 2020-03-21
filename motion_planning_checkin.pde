//Soucrces: https://www.geeksforgeeks.org/breadth-first-search-or-bfs-for-a-graph/
//Sources: https://docs.google.com/presentation/d/1_PFcKPQS5BDTEpIdGvDIW9M-vm2EWYxohHyCRSrWw1M/edit#
//Sources: DFS code from class

float vx;
float vy;

float agentxposit = 50;
float agentyposit = 750;
float goalx = 750;
float goaly = 50;
int radius = 100;
int agentAndTargetRadius = 25;
float xsphere = 400;
float ysphere = 400;
float xpoint;
float ypoint;
int numpoints = 12; //play around with num of points; more points leads to possibility of finding the ideal path
float[] xpoints = new float[numpoints]; 
float[] ypoints = new float[numpoints];


//For DFS
//array of booleans to determine if visited
boolean visited[]  = new boolean[numpoints]; 
ArrayList<Integer>[] neighbors = new ArrayList[numpoints];  //A list of neighbors can can be reached from a given node
int[] parent = new  int[numpoints];
//To store the path
ArrayList<Integer> path = new ArrayList(); 

int nextNode; //keeps track of the next path


void setup() {
  size(800, 800, P3D);
  findpoints();
  bfs();
  nextNode = path.size() - 2;
}

void draw() {

  background(255, 255, 255);
  if( nextNode > 0){
   updateposit(.15, nextNode);
  }

  //draw the paths
  for (int i = 0; i < numpoints; i++)
  {

    for (int j = 0; j < neighbors[i].size(); j++)
    {
      noFill();
      line(xpoints[i], ypoints[i], xpoints[neighbors[i].get(j)], ypoints[neighbors[i].get(j)]);
    }
  }

  //draw the nodes
  for (int i = 1; i < numpoints-1; i++) {

    pushMatrix();
    fill(0, 0, 255);
    //translate(xpoints[i], ypoints[i]);
    //sphere(radius*.1);
    circle(xpoints[i], ypoints[i], agentAndTargetRadius*.5);
    popMatrix();
  }

  pushMatrix();
  fill(0, 0, 255);
  //translate(400, 400);
  //sphere(radius);

  circle(xsphere, ysphere, radius);

  popMatrix();

  //agent is RED
  pushMatrix();
  fill(255, 0, 0);
  //translate(xsphere, ysphere);
  //sphere(50);
  translate(agentxposit, agentyposit);
  circle(50,750, agentAndTargetRadius*2);
  popMatrix();

  pushMatrix();
  fill(0, 255, 0);
  //translate(xsphere, ysphere);
  //sphere(50);
  circle(750, 50, agentAndTargetRadius);
  popMatrix();
}

//(x-xsphere)^2 + (y-ysphere)^2 = 400

void findpoints() {

  xpoints[0] = agentxposit;
  ypoints[0] = agentyposit;  
  println(xpoints[0]);
  println(ypoints[0]);

  xpoints[numpoints-1] = goalx;
  ypoints[numpoints-1] = goaly;  
  println(xpoints[numpoints-1]);
  println(ypoints[numpoints-1]);

  //points found are store in 1 to numpoints - 2
  // 0 is the start
  //numpoints - 1 is the goal
  for (int i = 1; i < numpoints-1; i++)
  {
    // find x points close to circle
    //find y points close to circle
    //xpoint = random(xsphere - (radius + 25), xsphere + radius + 25);
    //ypoint = random(ysphere - (radius + 25), ysphere + radius + 25);
   
    xpoint = random(xsphere - radius, xsphere + radius);
    ypoint = random(ysphere - radius, ysphere + radius);

    //while ((xpoint*xpoint) + (ypoint*ypoint) <= (radius + 25))
    while((xpoint - xsphere)*(xpoint - xsphere) + (ypoint - ysphere)*(ypoint - ysphere) <= (radius)*(radius))
    {

      xpoint += 5;
      ypoint += 5;
    }

    xpoints[i] = xpoint;
    ypoints[i] = ypoint;

    println(xpoints[i]);
    println(ypoints[i]);
  }
}

//Implement BFS

void bfs( ) {
  //initialize the arrays to represent the graph
  for (int i = 0; i < numpoints; i++)
  { 
    neighbors[i] = new ArrayList<Integer>(); 
    visited[i] = false;
    parent[i] = -1; //No partent yet
  }

  connect();
  println("List of Neghbors:");
  println(neighbors);

  int start = 0;
  int goal = numpoints - 1;


  ArrayList<Integer> fringe = new ArrayList(); 
  println("\nBeginning Search");

  visited[start] = true;
  fringe.add(start);
  println("Adding node", start, "(start) to the fringe.");
  println(" Current Fring: ", fringe);

  while (fringe.size() > 0) {
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goal) {
      println("Goal found!");
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++) {
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]) {
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
        println("Added node", neighborNode, "to the fringe.");
        println(" Current Fringe: ", fringe);
      }
    }
  }

  print("\nReverse path: ");
  int prevNode = parent[goal];
  path.add(goal);
  print(goal, " ");
  while (prevNode >= 0) {
    print(prevNode, " ");
    path.add(prevNode);
    prevNode = parent[prevNode];
  }
  print("\n");
  println("The path is:");
  println(path);
  print("\n");
}

void updateposit(float dt, int count)
{

  if(count == path.size()-2)
  { 
    vx = xpoints[path.get(count)] - agentxposit;
    vy = ypoints[path.get(count)] - agentyposit;
    
    agentxposit += vx*dt;
    agentyposit += vy*dt;
    nextNode--;
    
  }

  //check if the agent is near the next posit
  else if (((agentxposit - xpoints[count-1])*(agentxposit - xpoints[count-1]) + (agentyposit - ypoints[count-1])*(agentyposit - ypoints[count-1]) <= (agentAndTargetRadius*.5 + 25)*(agentAndTargetRadius*.5 + 25)) & count > 0)
  {
        
       vx = xpoints[path.get(count)] - agentxposit;
       vy = ypoints[path.get(count)] - agentyposit;
    
       agentxposit += vx*dt;
       agentyposit += vy*dt;
       nextNode--;
  }
  else
  {
     
       vx = xpoints[path.get(count)] - agentxposit;
       vy = ypoints[path.get(count)] - agentyposit;
    
       agentxposit += vx*dt;
       agentyposit += vy*dt;
       nextNode--;
  }
  println(agentxposit);
  println(agentyposit);
}


//checks obstacles and connects points
void connect()
{

  for (int i = 0; i < numpoints; i++)
  {

    float pocx;
    float pocy;
    pocx = xpoints[i] - xsphere;
    pocy = ypoints[i] - ysphere;



    float c; 
    c = (pocx*pocx) + (pocy*pocy) - (radius*radius);

    // This should avoid connecting with oneself and also checking twice for the same pair of points
    for ( int j = i+1; j < numpoints; j++)
    {
      float vx;
      float vy;

      vx = xpoints[i] - xpoints[j];
      vy = ypoints[i] - ypoints[j];

      float a; 
      a = vx*vx + vy*vy;

      float b;
      b = (2*vx*pocx) + (2*vy*pocy);
      if (sqrt(b*b - 4*a*c) > 0)
      {
      } else
      {
        neighbors[i].add(j);
      }
    }
  }
}
