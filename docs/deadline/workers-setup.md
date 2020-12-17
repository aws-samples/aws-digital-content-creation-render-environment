## Setup Deadline Monitor
The [Deadline Monitor](https://www.awsthinkbox.com/blog/deadline-monitor-interface-customization) is your main entry point for overseeing and managing your render farm. It's a powerful application that allows you to view, configure, and interact with the many of the moving parts that make up Deadline.

#### Launch the Monitor

`Applications -> Other -> Deadline Monitor 10`

![start-deadline.png](start-deadline.png)

#### Enable Super User Mode

`Tools -> Super User Mode`

![enable-super-mode.png](enable-super-mode.png)

#### Set up the workers group

`Tools -> Manage Groups`

![manage-groups.png](manage-groups.png)

1. Click on **New** to create a group.

1. Give the group name **linux_workers**

    ![workers-group.png](workers-group.png)

1. Select all the nodes desired with **CTR+A** and click on **Add**

    ![add-nodes.png](add-nodes.png)

1. Click **Ok**.

Next step is to set up [Blender plug-in](../blender/blender.md).
