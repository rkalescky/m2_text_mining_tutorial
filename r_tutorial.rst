Using R on ManeFrame II (M2)
============================

Set Up Twitter Application
--------------------------

#. `Sign up <https://twitter.com/signup>`_ for a new Twitter account if needed
   and `log in <https://twitter.com/login>`_.
#. Create a new Twitter application by going to
   `<http://twitter.com/apps/new>`_ and selecting "Create New App".
#. Fill in the required information for the application:

   * The **Name** and **Description** should be descriptive for the project.
   * The **Website** can be "http://www.smu.edu/".
   * The **Callback URL** should be set as "http://127.0.0.1:1410".
   * Agree to "Developer Agreement".

#. Press "Create your Twitter application" and you should be presented with a
   new page and a message stating that the application has been created.
#. Select the "Keys and Access Tokens" tab.
#. Press "Create my access token" at the bottom of the page.
#. Take note of the "Consumer Key (API Key)", "Consumer Secret (API Secret)",
   "Access Token", and "Access Token Secret" in a text file named ``twitter_oauth.txt`` with each of these values on different lines and in order given here, e.g.

.. code::
   77cK1wlNXwc9em05mCCP47B7p
   kGLw4hzCGqwYJgAtR4c8pX6WGVsHt1Y87AgOwAt1iWGivDeqfz
   927642335864815616-1yqvpzHTaK5RjwdQBulL7OPpDE7U9Du
   k4ruVhTzJE6jNHGbVmztGW0M4BaEQqaYywlUlVYWXxDUW

#. Select the "Permissions" tab.
#. Select "Read, Write and Access direct messages" under "Access".
#. Press "Update Settings".
#. Close the page.

Access Twitter Data from R
--------------------------

.. literalinclude:: twitteR_example.R
   :language: r

Running R on ManeFrame II
-------------------------

Types of Nodes On Which R Is to Run
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

First, you must identify the type of compute resource needed to run your
calculation. In the following table the compute resources are delineated
by resource type and the expected duration of the job. The duration and
memory allocations are hard limits. Jobs with calculations that exceed
these limits will fail. Once an appropriate resource has been identified
the partition and Slurm flags from the table can be used in the
following examples.

+-------------+-------------+-------------+-------------+-------------+
| Partition   | Duration    | Cores       | Memory [GB] | Slurm Flags |
+=============+=============+=============+=============+=============+
| development | 2 hours     | 36          | 256         | ``-p develo |
|             |             |             |             | pment``     |
+-------------+-------------+-------------+-------------+-------------+
| htc         | 1 day.      | 1           | 6           | ``-p htc -- |
|             |             |             |             | mem=6G``    |
+-------------+-------------+-------------+-------------+-------------+
| standard-me | 1 day       | 36          | 256         | ``-p standa |
| m-s         |             |             |             | rd-mem-s -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=250G`` |
+-------------+-------------+-------------+-------------+-------------+
| standard-me | 1 week      | 36          | 256         | ``-p standa |
| m-m         |             |             |             | rd-mem-m -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=250G`` |
+-------------+-------------+-------------+-------------+-------------+
| standard-me | 1 month     | 36          | 256         | ``-p standa |
| m-l         |             |             |             | rd-mem-l -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=250G`` |
+-------------+-------------+-------------+-------------+-------------+
| medium-mem- | 1 day       | 36          | 768         | ``-p medium |
| 1-s         |             |             |             | -mem-1-s -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=750G`` |
+-------------+-------------+-------------+-------------+-------------+
| medium-mem- | 1 week      | 36          | 768         | ``-p medium |
| 1-m         |             |             |             | -mem-1-m -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=750G`` |
+-------------+-------------+-------------+-------------+-------------+
| medium-mem- | 1 month     | 36          | 768         | ``-p medium |
| 1-l         |             |             |             | -mem-1-l -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=750G`` |
+-------------+-------------+-------------+-------------+-------------+
| medium-mem- | 2 weeks     | 24          | 768         | ``-p medium |
| 2           |             |             |             | -mem-2 --ex |
|             |             |             |             | clusive --m |
|             |             |             |             | em=750G``   |
+-------------+-------------+-------------+-------------+-------------+
| high-mem-1  | 2 weeks     | 36          | 1538        | ``-p high-m |
|             |             |             |             | em-1 --excl |
|             |             |             |             | usive --mem |
|             |             |             |             | =1500G``    |
+-------------+-------------+-------------+-------------+-------------+
| high-mem-2  | 2 weeks     | 40          | 1538        | ``-p high-m |
|             |             |             |             | em-2 --excl |
|             |             |             |             | usive --mem |
|             |             |             |             | =1500G``    |
+-------------+-------------+-------------+-------------+-------------+
| mic         | 1 week      | 64          | 384         | ``-p mic -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=374G`` |
+-------------+-------------+-------------+-------------+-------------+
| gpgpu-1     | 1 week      | 36          | 256         | ``-p gpgpu- |
|             |             |             |             | 1 --exclusi |
|             |             |             |             | ve --gres=g |
|             |             |             |             | pu:1 --mem= |
|             |             |             |             | 250G``      |
+-------------+-------------+-------------+-------------+-------------+
| dcv         | 1 day       | 36          | 256         | ``-p dcv -- |
|             |             |             |             | exclusive - |
|             |             |             |             | -mem=250G`` |
+-------------+-------------+-------------+-------------+-------------+

Running R Interactively with RStudio
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The RStudio graphical user interface can be run directly off of
ManeFrame II compute nodes using X11 forwarding or a VNC instance. The VNC method is recommended.

Running R Graphical User Interface Via X11 Forwarding
"""""""""""""""""""""""""""""""""""""""""""""""""""""

Running RStudio via X11 requires SSH with X11 forwarding and SFTP
access.

1. Log into the cluster using SSH with X11 forwarding enabled and run
   the following commands at the command prompt.
2. ``module load rstudio`` to enable access to R and RStudio.
3. ``srun <slurm partition flags> --x11=first --pty rstudio`` where
   ``<slurm partition flags>`` is the partition and associated Slurm
   flags for each partition outlined above.

**Example:**

.. code:: bash

       module load rstudio
       srun -p htc --mem=6G --x11=first --pty rstudio

Running R Graphical User Interface Using VNC
""""""""""""""""""""""""""""""""""""""""""""

Running RStudio via a VNC instance requires that a VNC client is installed on the local machine. While many VNC clients will likely work, these instructions are for using the RealVNC Viewer client, which is recommended. The first steps are to download and install the RealVNC client and need only be done once.

1. Download RealVNC Viewer client for your operating system from ` here.<https://www.realvnc.com/en/connect/download/viewer/>`_
2. Install the RealVNC client:

   Windows
      
      1. Double click the installer and follow instructions.
      
   Mac
   
      1. Click on DMG file to open
      2. Drag RealVNC application to the Applications folder
      
3. Log into the cluster using SSH and run the following commands at the
   command prompt.
4. ``srun -p workshop --pty vncpasswd`` to setup your VNC password. Choose something different than your SMU/M2 password. This step needs only be done once.
5. ``module load rstudio`` to enable access to R and RStudio.
6. ``cd`` to directory with RStudio Slurm submit script.
7. ``sbatch vnc_server.sbatch`` to submit job to queue.
8. ``squeue -u $USER`` and look for the job ID of the job with the name "vnc_rstudio".
9. Once the job has been allocated resources and started to run look in the output file of the job where the output file will have the file name "vnc_rstudio_<job_ID>.out", where ``<job_ID>`` is the job ID noted noted in the previous step. For example, ``tail -f vnc_rstudio_678824.out`` will show the output file and any updates to it. The running job takes about 30 to 60 seconds to start VNC and launch RStudio. Using ``tail -f `` is useful here because it will continuously show updates to the output file as the VNC and RStudio instances are started.
10. Once the output file shows lines similar to the following you will know that the VNC instance and RStudio have been properly started. Note the information give for "Using vnc port" and "Access VNC instance using". Note the information give for "Mac/Linux" if you are using a Mac or Linux computer.

.. code:: bash

   Using job port: 49976
   Using vnc port: 5917
   Mac/Linux: "ssh -L 5917:localhost:49976 rkalescky@login01.m2.smu.edu"
   Access VNC instance using: "localhost:5917"

11. Setup SSH port forwarding from your local computer to M2:

   Windows
   
      1. Start new Putty instance.
      2. Setup M2 login information as usual, but don't log in yet.
      3. Once the usual M2 login information has been entered, go to "Category:" (on the left), "Connection", "SSH", and then "Tunnels".
      4. Under "Add new forwarded port:", give the value of "Using vnc port" for "Source port" and "Access VNC instance using:" for "Destination" and then click "Add".
      5. Press "Open" to log into M2.
       
   Mac
   
      1. Open new Terminal instance or new tab
      2. Copy and paste into the new instance the information noted for "Mac/Linux" beginning, e.g. ``ssh -L 5917:localhost:49976 rkalescky@login01.m2.smu.edu``. Press enter and give M2 password when prompted.

12. Start the "VNC Viewer" application.
13. Enter the information from "Access VNC instance using" in the "Enter a VNC Server address or search" field and press enter.
14. You may be prompted concerning an "Unencrypted connection", if so press "Continue". Note that the connection is actually encrypted using SSH.
15. Enter VNC password setup previously and you will be presented with a window in which RStudio is running.

Running R Non-Interactively in Batch Mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

R scripts can be executed non-interactively in batch mode in a myriad
ways depending on the type of compute resource needed for the
calculation, the number of calculations to be submitted, and user
preference. The types of compute resources outlined above. Here, each
partition delineates a specific type of compute resource and the
expected duration of the calculation. Each of the following methods
require SSH access. Examples can be found at ``/hpc/examples/r`` on
ManeFrame II.

Submitting a R Job to a Queue Using Wrap
""""""""""""""""""""""""""""""""""""""""

A R script can be executed non-interactively in batch mode directly
using sbatch's wrapping function.

1. Log into the cluster using SSH and run the following commands at the
   command prompt.
2. ``module load r`` to enable access to R.
3. ``cd`` to directory with R script.
4. ``sbatch <slurm partition flags> --wrap "R --vanilla < <R script file name>"``
   where ``<slurm partition flags>`` is the partition and associated
   Slurm flags for each partition outlined in the table above. and
   ``<R script file name>`` is the R script to be run.
5. ``squeue -u $USER`` to verify that the job has been submitted to the
   queue.

**Example:**

.. code:: bash

       module load r
       sbatch -p standard-mem-s --exclusive --mem=250G --wrap "R --vanilla < example.R"

Submitting a R Job to a Queue Using a Submit Script
"""""""""""""""""""""""""""""""""""""""""""""""""""

A R script can be executed non-interactively in batch mode by creating
an Sbatch script. The Sbatch script gives the Slurm resource scheduler
information about what compute resources your calculation requires to
run and also how to run the R script when the job is executed by Slurm.

1. Log into the cluster using SSH and run the following commands at the
   command prompt.
2. ``cd`` to directory with R script
3. ``cp /hpc/examples/r/r_example.sbatch <descriptive file name>`` where
   ``<descriptive file name>`` is meaningful for the calculation being
   done. It is suggested to not use spaces in the file name and that it
   end with .sbatch for clarity.
4. Edit the Sbatch file using using preferred text editor. Change the
   partition and flags and R script file name as required for your
   specific calculation.

.. literalinclude:: r_job_example.sbatch
   :language: bash

5. ``sbatch <descriptive file name>`` where ``<descriptive file name>``
   is the Sbatch script name chosen previously.
6. ``squeue -u $USER`` to verify that the job has been submitted to the
   queue.

Submitting Multiple R Jobs to a Queue Using a Single Submit Script
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

Multiple R scripts can be executed non-interactively in batch mode by
creating an single Sbatch script. The Sbatch script gives the Slurm
resource scheduler information about what compute resources your
calculations requires to run and also how to run the R script for each
job when the job is executed by Slurm.

1. Log into the cluster using SSH and run the following commands at the
   command prompt.
2. ``cd`` to the directory with the R script or scripts
3. ``cp /hpc/examples/r/r_array_example.sbatch <descriptive file name>``
   where ``<descriptive file name>`` is meaningful for the calculations
   being done. It is suggested to not use spaces in the file name and
   that it end with .sbatch for clarity.
4. Edit the Sbatch file using using preferred text editor. Change the
   partition and flags, R script file name, and number of jobs that will
   be executed as required for your specific calculation.

.. literalinclude:: r_job_array_example.sbatch
   :language: bash

5. ``sbatch <descriptive file name>`` where ``<descriptive file name>``
   is the Sbatch script name chosen previously.
6. ``squeue -u $USER`` to verify that the job has been submitted to the
   queue.





