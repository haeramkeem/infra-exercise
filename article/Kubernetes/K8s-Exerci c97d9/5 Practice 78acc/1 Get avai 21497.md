# 1. Get available nodes and pods

1. `kubectl get nodes`
    - Show all information for node
    - `-o $OPTIONS`: Specify the options
        - `wide`: Show additional information for each pod
    - Examples
        
        ```bash
        kubectl get nodes # Show nodes in default columns
        Kubectl get nodes -o wide # Show nodes in extended columns
        ```
        
2. `kubectl get pods`
    - Show all information for pods
    - `-w`: Watch → Track and print the differences like `tail -f`
    - `-n $NAMESPACE`: Specify the namespace for the pods → Default is the *default namespace*
    - `-o $OUTFORM`: Specify the form of output
        - `wide`: Show additional information for each pod
        - `yaml`, `json`: Show information in “YAML” or “JSON” form
        - `-o=custom-columns=$HEADER:$JSON_PATH_EXPR`: Show information in custom column
            - Custom column example
                
                ```bash
                kubectl get pods -o=custom-columns=\
                NAME:.metadata.name,\
                IP:.status.podIP,\
                STATUS:.status.phase,\
                NODE:.spec.nodeName
                ```
                
        - `-o=jsonpath='{$JSONPATH}'`: Show information in JSONPath
            - Take a look for JSONPath support:
                
                [JSONPath Support](https://kubernetes.io/docs/reference/kubectl/jsonpath/)
                
            - Example
                
                ```bash
                kubectl get node node01 -o=jsonpath='{.status.addresses[0].address}' # Get external IP for node "node01"
                ```
                
    - Examples
        
        ```bash
        kubectl get pods # Show pods for the default namespace
        kubectl get pods -n kube-system # Show pods for the Kubernetes system pods
        kubectl get pods -o wide # Show pods with additional information
        ```