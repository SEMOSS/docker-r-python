# CFG Python Environment
This branch of the respository contains the Docker image and pyproject.toml file to install the necessary packages for the CFG Python environment. This setup is intended to be used with the [Astral UV](https://docs.astral.sh/uv/) platform.

## Local Environment Installation
### **Install Python 3.12.9**
(This assumes you are using pyenv for Windows)
1. `pyenv update` to update pyenv
2. `pyenv install 3.12.9` to install Python 3.12.9
3. `pyenv global 3.12.9` to set the global version of Python to 3.12.9
4. Open a new terminal and verify the Python version with `python --version`


### **Install uv and setup virtual environment**
1. Install [uv](https://docs.astral.sh/uv/getting-started/installation/) with the command:
    ```powershell
    powershell -ExecutionPolicy ByPass -c "irm https://astral.sh/uv/install.ps1 | iex"
    ```
2. Navigate to this directory in the terminal
3. `uv venv` to create a virtual environment
4. `uv pip install -r pyproject.toml --extra cpu` or `uv pip install -r pyproject.toml --extra gpu` to install the necessary packages depending on your system's capabilities
5. `uv pip list` to verify the packages are installed

### **Setup SEMOSS with your Python virtual environment**
1. Copy the path of the virtual environment including the \Scripts folder.
2. You now have 2 options, you can either:
    - Update your RDF_Map.prop file to include the PYTHONHOME variable
    - **OR**
    - Add the PYTHONHOME variable to your system environment variables
3. If adding to the RDF_Map.prop file, you should format your path with the double blackslashes to your appropriate path like so:
    ```properties
    PYTHONHOME C:\\Users\\rweiler\\Desktop\\REPOS\\docker-r-python\\.venv\\Scripts
    ```
4. If adding to your system environment variables, you should format your path with the single blackslashes to your appropriate path like so:
    ```properties
    PYTHONHOME C:\Users\rweiler\Desktop\REPOS\docker-r-python\.venv\Scripts
    ```
**NOTE**: If you chose to add this to your system environment variables, you should know that this environment will be used for all Python scripts that are run on your machine unless you use a different virtual environment.

## Adding and Removing Packages
1. `uv venv` to create the virtual environment (if not already created)
2. `uv pip install -r pyproject.toml --extra cpu` or `uv pip install -r pyproject.toml --extra gpu` to install the necessary packages depending on your system's capabilities
3. `uv add <package>` to add a package
4. `uv remove <package>` to remove a package
5. `uv pip list` to verify the packages are installed

## Issues

- The latest version of `datasets` (`v3.3.2`) causes an issue in `faiss_client.py`. `TypeError at line 297 of source string: DatasetInfo.__init__() got an unexpected keyword argument 'task_templates'`
    - Downgrading to `datasets==2.21.0`


## Omitted Packages

The following packages were omitted from the `pyproject.toml` that are included in the original CUDA12 branch. If you require any of the following libaries please reach out to Ryan Weiler or Kunal Patel.

- `farm-haystack`
- `moviepy`
- `unstructured`
- `youtube-search`
- `paddlepaddle`
- `paddlepaddle-gpu`