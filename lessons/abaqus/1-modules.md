-   Part

    The Part module allows you to create individual parts by sketching their geometry directly in Abaqus/CAE or by importing their geometry from other geometric modeling programs.

-   Property

    A section definition contains information about the properties of a part or a region of a part, such as a region's associated material definition and cross-sectional geometry. In the Property module you create section and material definitions and assign them to regions of parts.

-   Assembly

    When you create a part, it exists in its own coordinate system, independent of other parts in the model. You use the Assembly module to create instances of your parts and to position the instances relative to each other in a global coordinate system, thus creating an assembly. An Abaqus model contains only one assembly.

-   Step

    You use the Step module to create and configure analysis steps and associated output requests. The step sequence provides a convenient way to capture changes in a model (such as loading and boundary condition changes); output requests can vary as necessary between steps.

-   Interaction

    In the Interaction module you specify mechanical and thermal interactions between regions of a model or between a region of a model and its surroundings. An example of an interaction is contact between two surfaces. Other interactions that may be defined include constraints, such as tie, equation, and rigid body constraints. Abaqus/CAE does not recognize mechanical contact between part instances or regions of an assembly unless that contact is specified in the Interaction module; the mere physical proximity of two surfaces in an assembly is not sufficient to indicate any type of interaction between the surfaces. Interactions are step-dependent objects, which means that you must specify the analysis steps in which they are active.

-   Load

    The Load module allows you to specify loads, boundary conditions, and predefined fields. Loads and boundary conditions are step-dependent objects, which means that you must specify the analysis steps in which they are active; some predefined fields are step-dependent, while others are applied only at the beginning of the analysis.

-   Mesh

    The Mesh module contains tools that allow you to generate a finite element mesh on an assembly created within Abaqus/CAE. Various levels of automation and control are available so that you can create a mesh that meets the needs of your analysis.

-   Optimization

    The Optimization module allows you to create an optimization task that can be used to optimize the topology of your model given a set of objectives and constraints. For more information, see Chapter 18, “The Optimization module,” of the Abaqus/CAE User's Manual.

-   Job

    Once you have finished all of the tasks involved in defining a model, you use the Job module to analyze your model. The Job module allows you to interactively submit a job for analysis and monitor its progress. Multiple models and runs may be submitted and monitored simultaneously.

-   Visualization

    The Visualization module provides graphical display of finite element models and results. It obtains model and result information from the output database; you can control what information is written to the output database by modifying output requests in the Step module.

-   Sketch

    Sketches are two-dimensional profiles that are used to help form the geometry defining an Abaqus/CAE native part. You use the Sketch module to create a sketch that defines a planar part, a beam, or a partition or to create a sketch that might be extruded, swept, or revolved to form a three-dimensional part.