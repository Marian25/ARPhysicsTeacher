<h1 align="center">ARPhysicsTeacher</h1>

## General Description

The scope of this project is to create an educational app which uses augmented reality to permit users to simulate and analyse physics problem with inclined plane.

The virtual objects that can be used are: 
* a physical body exemplified by a cube that has a single variable: the mass expressed in kg;
* an inclined plane exemplified by a prism that has three variables: the plan angle in degrees, friction coefficient, and plan height in meters;
* a pulley;

Additionally, users can add forces to the bodies in the scene to accurately shape a real situation. The simulation is played when the left bottom button is pressed and consists in visualizing the effect of forces, gravity and collision between bodies in the scene, matching roughly the behavior in the real world. At this point, the simulation can be stopped to update the position of the bodies or to modify the forces, or the simulation can be brought to the initial state.

## Implementation

The app is available only in landscape mode. In bottom center is the button to add virtual objects. When this button is pressed a *UICollectionView* appears in the form of a *UIPopupViewController* in which all the available virtual objects are listed. Below is represented the way that the objects are added in scene:

### 1. Adding a cube
<p align="center">
    <img src="Demo_gifs/add_cube.gif"/>
</p>

### 2. Adding a ramp
<p align="center">
    <img src="Demo_gifs/add_ramp.gif"/>
</p>

The start/stop button of the simulation can be found in bottom left. In bottom right is the button which permits to add a force on a physical body. Next, the user needs to choose a value in newtons and a direction for the force.

<p align="center">
    <img src="Demo_gifs/add_force.gif"/>
</p>

For placing the objects in the scene is necessary to detect a plane on which to place the objects. For this thing I set the *planeDetection* variable of the scene configuration to *horizontal*. The UI element which gives feedback to the user when a plane is detected is a square partially closed which consists of 8 segments.

This square stays on the camera direction, and when a plane is detected, through an animation, the square is being closed.

<p align="center">
    <img src="Demo_gifs/plane_detection.gif"/>
</p>

When the plus button is pressed, visible only if the camera is placed towards a detected plane, it determines the display of a collection as a popup containing the available virtual objects. By clicking on an object in the collection, the object is added to the scene.

Before adding to the scene, the user needs to enter the values for the object's variables. A physical body can be rotated or the user can change its position using panning on the detected plane. Through translation we can place bodies on top of each other, so we can create a multi-body construction. Below is exemplified the way the virtual objects can interact:

### 1. Cube over cube

<p align="center">
    <img src="Demo_gifs/cube_over_cube.gif"/>
</p>

### 2. Cube over ramp

<p align="center">
    <img src="Demo_gifs/cube_over_ramp.gif"/>
</p>
