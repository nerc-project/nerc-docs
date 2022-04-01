# Object Storage

OpenStack Object Storage (Swift) is a highly available, distributed, eventually consistent
object/blob store. Object Storage is used to manage cost-effective and long-term
preservation and storage of large amounts of data across clusters of standard server
hardware. The common use cases include the storage, backup and archiving of unstructured
data, such as documents, static web content, images, video files, and virtual
machine images, etc.

The end-users can interact with the object storage system through a RESTful HTTP
API i.e. the Swift API or use one of the many client libraries that exist for all
of the popular programming languages, such as Java, Python, Ruby, and C# based on
provisioned quotas. Swift also supports and is compatible with [Amazon's Simple
Storage Service (S3) API](https://docs.openstack.org/swift/latest/s3_compat.html)
that makes it easier for the end-users to move data between multiple storage end
points and supports hybrid cloud setup.

## Access by Web Interface

To get started, navigate to Project -> Object Store -> Containers.

![Object Store](images/object-store.png)

### Create a Container

In order to store objects, you need at least one **Container** to put them in.
Containers are essentially top-level directories. Other services use the
terminology **buckets**.

Click Create Container. Give your container a name.

![Create a Container](images/create-container.png)

!!! note "Important Note"
        The container name needs to be unique, not just within your project but
        across all of our OpenStack installation. If you get **an error message**
        after trying to create the container, try giving it a more unique name.

For now, leave the "Container Access" set to **Private**.

### Upload a File

Click on the name of your container, and click the Upload File icon as shown below:

![Container Upload File](images/upload-file-container.png)

Click Browse and select a file from your local machine to upload.

It can take a while to upload very large files, so if you're just testing it out
you may want to use a small text file or similar.

![Container Upload Popup](images/container-upload-popup.png)

By default the File Name will be the same as the original file, but you can change
it to another name. Click "Upload File". Your file will appear inside the container
as shown below once successful:

![Successful File Upload](images/container-file-upload-success.png)

### Using Folders

Files stored by definition do not organize objects into folders, but you can use
folders to keep your data organized.

On the backend, the folder name is actually just prefixed to the object name, but
from the web interface (and most other clients) it works just like a folder.

To add a folder, click on the "+ folder" icon as shown below:

![Upload Folder on Container](images/folder-upload-container.png)

### Make a container public

Making a container public allows you to send your collaborators a URL that gives
access to the container's contents.

Click on your container's name, then check the "Public Access" checkbox. Note that
"Public Access" changes from "Disabled" to "Link".

![Setting Container Public Access](images/container-public-access-setting.png)

Click "Link" to see a list of object in the container. This is the URL of your container.

!!! note "Important Note"
        Anyone who obtains the URL will be able to access the container, so this
        is not recommended as a way to share sensitive data with collaborators.

In addition, everything inside a public container is public, so we recommend creating
a separate container specifically for files that should be made public.

To download the file `test-file` we would use the [following url](https://stack.nerc.mghpcc.org:13808/v1/AUTH_4c5bccef73c144679d44cbc96b42df4e/unique-container-test/test-file)

**Or**, you can just click on "Download" next to the file's name as shown below:

![Download File From Container](images/download-file-from-container.png)

You can also interact with public objects using a utility such as `curl`:

    ```sh
    # curl https://stack.nerc.mghpcc.org:13808/v1/AUTH_4c5bccef73c144679d44cbc96b42df4e/unique-container-test
    test-file
    ```

To download a file:

    ```sh
    # curl -o local-file.txt https://stack.nerc.mghpcc.org:13808/v1/AUTH_4c5bccef73c144679d44cbc96b42df4e/unique-container-test/test-file
    ```

### Make a container private

You can make a public container private by clicking on your container's name,
then uncheck the "Public Access" checkbox. Note that "Public Access" changes
from "Link" to "Disabled".

This will deactivate the public URL of the container and then it will show "Disabled".

![Disable Container Public Access](images/disable_public_access_container.png)

## Access by using APIs

### Swift Interface

This is a python client for the Swift API. There's a [Python API](https://github.com/openstack/python-swiftclient)
(the `swiftclient` module), and a command-line script (`swift`).

[Python Swift Client page at PyPi](https://pypi.org/project/python-swiftclient/)

    - Install `python-swiftclient` and `python-keystoneclient`

    ```sh
    # pip install python-swiftclient python-keystoneclient
    ```

    - Swift authenticates using a user, tenant, and key, which map to your OpenStack username, project, and password.
    For this, you need to download the **"NERC's OpenStack RC File"** with the credentials for
    your NERC project from the [NERC's OpenStack dashboard](https://stack.nerc.mghpcc.org/).
    Then you need to source that RC file using: `source *-openrc.sh`. You can
    [read here](https://github.com/nerc-project/terraform-nerc#how-to-get-credential-to-connect-nercs-openstack)
    on how to do this.

    By sourcing the "NERC's OpenStack RC File", you will set the all required environmental variables by using
    your openstackrc file, and then type the following command to get a lits of your containers:

    ```sh
    swift --os-auth-url $OS_AUTH_URL --auth-version $OS_IDENTITY_API_VERSION\
      --os-application-credential-id $OS_APPLICATION_CREDENTIAL_ID \
      --os-application-credential-secret $OS_APPLICATION_CREDENTIAL_SECRET \
      --os-auth-type $OS_AUTH_TYPE list
    ```

    This will output your existing container on your project, for e.g.

    `unique-container-test`

    To upload a file to the above listed i.e. `unique-container-test`, you can run following command:

    ```sh
    swift --os-auth-url $OS_AUTH_URL --auth-version $OS_IDENTITY_API_VERSION\
      --os-application-credential-id $OS_APPLICATION_CREDENTIAL_ID \
      --os-application-credential-secret $OS_APPLICATION_CREDENTIAL_SECRET \
      --os-auth-type $OS_AUTH_TYPE upload unique-container-test ./README.md
    ```

    !!! note "Helpful Tip"
            Type `swift -h` to learn more about using the swift commands. The client has a `--debug` flag, which can be
            useful if you are facing any issues.

---
