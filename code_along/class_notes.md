# 05 Users and Roles
- Why?
    - collaborate and manage security whit users and roles in snowflake
![](/images/user_roles.png)
- Access control in snowflake:
    - **DAC** (Discretionary access control) 
        - ecah object has an owner
        - an owner can grant privilege to access the object
    - **RBAC** (Role-based-access control)
        - access privilege assignes to roles
        - roles assigned to users and other roles 
    - *E.g. Users Learnpoint (permission = **privilege**)*
    - **[Elvin - UL Role]** 
        - permission to add courses. 
        - permission ta edit studentinfo
    - **[Debbie - Teacher Role]** 
        - permission to grade
        - permission to upload homework 
    - **[We - Rtudent Role]** 
        - permission to submit
### Diffrens between Role and Users
- Role - The actual role such as "Teacher"
- User - A person such as "Debbie"
![](/images/user_privilege.png)

### Privileges are inherited
- Roles can be GRANTed to different USERs
- Privileges are inherited based on how much access a role or user should have

## System-defined roles - roels & usage
![](/images/system_roles.png)
#### ORGADMIN
- manage operations in organizational level
- create accounts in organizations
#### ACCOUNTADMIN
- top level role
- grant to few users
#### SECURITYADMIN
- manage object grants globally
- even if he or she doesnt own the object they can grant it to other
- they can't use the object but grant manage to other roles
#### SYSADMIN
- create warehouse
- create database
- create other object
#### USERADMIN
- user and role management
- use to create user
#### PUBLIC 
- objects owned by PUBLIC is available to everyone

## Hierarchy of roles and inherited privileges
- ACCOUNTADMIN - account administrator
- SYSADMIN - object administrator
- SECURITYADMIN - GRANT manager
- USERADMIN - create users

![](/images/hierarchy.png)

More on users & roles: https://docs.snowflake.com/en/user-guide/security-access-control-considerations#example


# DLT (Data Load Tool)
![](/images/dlt_staging_layer.png)

### dlthub
- a Data Loading Tool in python
![](/images/dlt_dlthub.png)

### setup dlthub 
#### 1.To upgrade the uv environment
```bash
pip install --upgrade uv
```
#### 2. To create the virual environment
bash ```
uv init --no-package --python 3.13
```
#### 3. To install dependencies
bash ```
uv add "dlt[snowflake]" "dlt[parquet]" pandas ipykenel
```

### Why do we need secrets.toml?
- We need the user in secrets.toml for dlt 