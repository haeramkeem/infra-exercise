# 2. Structure and Concepts

# Basic structure

![Source: Kubernetes official documentation](2%20Structur%2038f03/structure.png)

Source: Kubernetes official documentation

- **Worker Node** (or just **Node**) is a worker machine for the Kubernetes cluster
    - Each container is running on this machine
    - (1) *kubelet,* (2) *kube-proxy*, and (3) *Container Runtime Interface(CRI)* are the components of the worker node
- **Master Node** (or **Control Plane**) is the main controller for the overall Kubernetes cluster
    - Usually, **Control Plane** runs on a separate machine, and it’s called **Master Node**
    - (1) *API Server*, (2) *etcd*, (3) *Scheduler*, (4) *Kubernetes Controller Manager*, and (5) *Cloud Controller Manager* are the components of the master node

## Node Components

- Container
    - Process for one or more purposes running on an isolated execution environment
- Kubelet
    - An agent that runs on each node in the cluster. It makes sure that containers are running in a pod
    - This agent manages the controllers and pods for the node
    - So, when Kubelet doesn’t work, creating and deleting the pods will not be working either
- Kubectl
    - This agent provides Command Line Interface (CLI) to control the Kubernetes cluster
    - It uses the Kubernetes API Server, so installing Kubectl to the master node (where API Server is installed) would be nice
- Container Runtime Interface (CRI)
    - The container runtime is the software that is responsible for running containers
    - `Docker` is a one example

## Control Plane Components

- Kubernetes API Server (kube-apiserver)
    - It’s a component of the Kubernetes control plane (master node)
    - All the commands to the Kubernetes go through the API Server
    - Even Kubectl works with the help of API Server
    - So, u can think of it as an interface that provides controlling the Kubernetes cluster → The API server is the front end for the Kubernetes control plane
- etcd
    - Kubernetes’s backing storage for all cluster data
    - Mainly cooperates with *API Server*
    - That is, it cooperates with *API Server* to keep track of  nodes & pods state
    - Stores data in a *key-value* way
- Scheduler (kube-scheduler)
    - Watches for newly created pods with no assigned node, and selects a node for them to run on
    - In other words, **Scheduler** allocates pods to the node
- Kubernetes Controller Manager (c-m)
    - Kubernetes Controller Manager integrates the controllers for Kubernetes’s objects
    - The concept of *controller* is explained in `Concepts` chapter
- Cloud Controller Manager (c-c-m)
    - When the Kubernetes cluster is running on the cloud, **Cloud Controller Manager** controls the feature that the cloud supports
    - For example, *Node controller* checks cloud instance-based nodes to determine if the node is alive
    - *Route controller* controls the route for cloud
    - *Service controller* controls the load balancer that the cloud provider supports

---

# Concepts

## Object

- **Kubernetes Objects** are persistent entities in the Kubernetes system
- Kubernetes uses objects to represent the state of your cluster
- And almost every object has two nested fields: `spec` and `status`
- `spec` is the *desired state*: u have to specify it when u creates the object
    - U can do it with the kubectl → option, or file (YAML or JSON)
    - Or directly with API Server → request body
- `status` is the *current state*: Kubernetes will steadily struggle to match the `status` with the `spec`
- And the purpose of the **Controller** is to match the `status` of the object with the `spec`

### Basic Object

- In Kubernetes, 4 kinds of **Basic Objects** are supported: **Pod**, **Namespace**, **Volume**, and **Service**
1. Pod
    - Group of one or more Docker containers with shared namespaces, shared filesystem volumes, and a specification for how to run the containers
    - Smallest deployable units of computing that you can create and manage in Kubernetes
    - When a pod consists of a single container, u can think of it as a **wrapper of a container**
        - Integrate one or more application containers that are relatively tightly coupled to serve a single cohesive (closely united) unit of service - “Logical Host”
    - And when a pod consists of multiple containers, it is kinda **capsule of the containers**
        - These containers are co-located on a single “Node”
        - And they are co-managed by the system
        - Also, they are activated in a synchronized way → This is called *co-scheduling*
        - The containers can share resources and dependencies, communicate with one another, and coordinate when and how they are terminated
        - Example for multi-container pod
            - One container serves data stored in a shared volume to the public, while a separate *sidecar* container refreshes or updates those files. The Pod wraps these containers, storage resources, and an ephemeral network identity together as a single unit.
        - Along with the application containers, *init container* and *ephemeral (temporary) container → for debugging* can be integrated into the pod
        - Kubernetes does not directly manage the container; It controls the **pod** instead of each container
    - Think about pods this way: Most of the pods are just wapping a container, but not all pods does that
    - A Pod is just a logical thing → the concept of “wrapper” of the container makes u feel like a Pod is stored in the worker node (in the logical perspective, it’s correct), but a Pod is stored in a master node in physical perspective
        - But u can think that a Pod is stored in the worker node → It doesn’t matter where a pod is stored physically
2. Namespace
    - N**amespace** is kinda *group* of the workload resources
    - The purpose of the **Namespace** is the isolation of the workload resources
        - But, **Namespace** is just logical isolation; It’s quite different from physical isolation in several ways, such as *security perspective*
    - By default, all the resources have *default namespace*
    - But other namespaces are exists in Kubernetes, such as *kube-system*, which is a group of pods related to the Kubernetes system
3. Volume
    - **Volume** provides the filesystem directory for each pod
    - By default, *temporary* volume is assigned to each pod
    - But, *persistent* volume is also supported, that remains after the pod is deleted
4. Service
    - **Service** is kinda *load balancer*, *gateway* to the outside
    - **Service** updates the connection when a pod is replaced (i.e. updating the IP address of the existing pod)

### Workload, Workload Resource, Controller, PodTemplate

- A **Workload** is an application running on Kubernetes
    - Understanding the concept of **Workload** is very sucks
    - So, just think about it as *Application*
- And **Workload Resources** are like a group of objects (mostly pods) for running the application
    - To manage a set of pods more efficiently and easily, u don’t have to manage each pod on ur own
    - Instead, u can use **Workload Resources** to manage them
    - And watching and managing each workload resource is what **Controller** does
        - As mentioned above, The **Controller** always struggle to match the state of the Workload Resource and its included objects with the desired state
    - For example, the **Controller** keeps track of the state of pods for the workload resources and replaces a pod when some pods are not desired state
    - Pods that are located in a single workload resource has the same **PodTemplate**; In other words, *Controller* automatically creates pods for the workload resource using the **PodTemplate**
        - So, u can think of it as How to create each pod for the workload resource
        - Also, u can think of it as the Desired state of each pod for the workload resource
        - So, when the pod template of one workload resource is changed, all the pods inside it are replaced based on that pod template sequentially
- Kubernetes supports 4 kinds of **Workload Resources**: Deployment (+ ReplicaSet). DemonSet, StatefulSet, Job (+ CronJob)
1. **Deployment (+ ReplicaSet)**
    - To deal with some cases like traffic issues, The copy of the pods are included in one Workload Resources; These copies are called **Replica**
    - Thus, **ReplicaSet** is a group of **Replica**s
    - But **ReplicaSet** only ensures the number of the pods included; **Deployment** is kinda wrapper for **ReplicaSet** to support more feature
    - The main characteristic of the **Deployment** and **ReplicaSet** is *Stateless*. That is, they don’t rely on the state → They say Database is one example for the state-relying application → I think the *state* is kinda additional volume in this context
2. **StatefulSet**
    - Unlike Deployment and ReplicaSet, **StatefulSet** rely on the *state* (external volume)
3. **DaemonSet**
    - **Daemon** is a pod that runs on every node (of course, that node has to be matched with *object spec* of **DaemonSet**), and only one per a node
    - **DaemonSet** is a group of these daemon pods
    - Thus, when a node is added to the cluster, (and if that node is matched to the *object spec* of **DaemonSet**), *kube-scheduler* schedules a copy of the pod to the node
4. **Job (+ Cron Job)**
    - **Job** refers to a group of pods that is terminated after execution
    - So, unlike other workload resources, the pods of a **Job** are executed only once
    - And the **Cron Job** is one kind of Job, but it is executed based on time-schedule