---- tablas

select * from BranchOffice
select * from Company
select * from CostCenter
select * from EntityCatalog
select * from permirole
select * from permirolerecord
select * from Permission
select * from permiuser
select * from permiuserrecord
select * from [Role]
select * from [user]
select * from usercompany
select * from userrole


-- Create Company Table  --------------------------------------------------------------------------------
	CREATE TABLE Company (
	    -- Primary Key
	    id_compa BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para la compa��a
	    
	    -- Company Information
	    compa_name NVARCHAR(255) NOT NULL,                        -- Nombre legal completo de la compa��a
	    compa_tradename NVARCHAR(255) NOT NULL,                   -- Nombre comercial o marca de la compa��a
	    
	    -- Document Information
	    compa_doctype NVARCHAR(2) NOT NULL                        -- Tipo de documento de identificaci�n de la compa��a
	        CONSTRAINT CK_Company_DocType 
	        CHECK (compa_doctype IN ('NI', 'CC', 'CE', 'PP', 'OT')),
	    compa_docnum NVARCHAR(255) NOT NULL,                      -- N�mero de identificaci�n fiscal o documento legal de la compa��a
	    
	    -- Location Information
	    compa_address NVARCHAR(255) NOT NULL,                     -- Direcci�n f�sica de la compa��a
	    compa_city NVARCHAR(255) NOT NULL,                        -- Ciudad donde est� ubicada la compa��a
	    compa_state NVARCHAR(255) NOT NULL,                       -- Departamento o estado donde est� ubicada la compa��a
	    compa_country NVARCHAR(255) NOT NULL,                     -- Pa�s donde est� ubicada la compa��a
	    
	    -- Contact Information
	    compa_industry NVARCHAR(255) NOT NULL,                    -- Sector industrial al que pertenece la compa��a
	    compa_phone NVARCHAR(255) NOT NULL,                       -- N�mero de tel�fono principal de la compa��a
	    compa_email NVARCHAR(255) NOT NULL,                       -- Direcci�n de correo electr�nico principal de la compa��a
	    compa_website NVARCHAR(255) NULL,                         -- Sitio web oficial de la compa��a
	    
	    -- Media
	    compa_logo NVARCHAR(MAX) NULL,                           -- Logo oficial de la compa��a
	    
	    -- Status
	    compa_active BIT NOT NULL DEFAULT 1                       -- Indica si la compa��a est� activa (1) o inactiva (0)
	);

-- Create CostCenter Table  -----------------------------------------------------------------------------------------
	CREATE TABLE CostCenter (
	    -- Primary Key
	    id_cosce BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el centro de costo
	    
	    -- Foreign Keys
	    company_id BIGINT NOT NULL                                -- Compa��a a la que pertenece este centro de costo
	        CONSTRAINT FK_CostCenter_Company 
	        FOREIGN KEY REFERENCES Company(id_compa),
	    
	    cosce_parent_id BIGINT NULL                               -- Centro de costo superior en la jerarqu�a organizacional
	        CONSTRAINT FK_CostCenter_Parent 
	        FOREIGN KEY REFERENCES CostCenter(id_cosce),
	    
	    -- Basic Information
	    cosce_code NVARCHAR(255) NOT NULL,                        -- C�digo �nico que identifica el centro de costo
	    cosce_name NVARCHAR(255) NOT NULL,                        -- Nombre descriptivo del centro de costo
	    cosce_description NVARCHAR(MAX) NULL,                     -- Descripci�n detallada del centro de costo y su prop�sito
	    
	    -- Financial Information
	    cosce_budget DECIMAL(15,2) NOT NULL DEFAULT 0,            -- Presupuesto asignado al centro de costo
	    
	    -- Hierarchical Information
	    cosce_level SMALLINT NOT NULL DEFAULT 1                   -- Nivel en la jerarqu�a de centros de costo (1 para nivel superior)
	        CONSTRAINT CK_CostCenter_Level 
	        CHECK (cosce_level > 0),
	    
	    -- Status
	    cosce_active BIT NOT NULL DEFAULT 1,                      -- Indica si el centro de costo est� activo (1) o inactivo (0)
	    
	    -- Unique constraint for company and cost center code combination
	    CONSTRAINT UQ_Company_CostCenterCode UNIQUE (company_id, cosce_code)
	);

-- Create BranchOffice Table  -------------------------------------------------------------------------
	CREATE TABLE BranchOffice (
	    -- Primary Key
	    id_broff BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para la sucursal
	
	    -- Company Reference
	    company_id BIGINT NOT NULL                                -- Compa��a a la que pertenece esta sucursal
	        CONSTRAINT FK_BranchOffice_Company 
	        FOREIGN KEY REFERENCES Company(id_compa),
	    
	    -- Branch Office Information
	    broff_name NVARCHAR(255) NOT NULL,                        -- Nombre descriptivo de la sucursal
	    broff_code NVARCHAR(255) NOT NULL,                        -- C�digo �nico que identifica la sucursal dentro de la empresa
	    
	    -- Location Information
	    broff_address NVARCHAR(255) NOT NULL,                     -- Direcci�n f�sica de la sucursal
	    broff_city NVARCHAR(255) NOT NULL,                        -- Ciudad donde est� ubicada la sucursal
	    broff_state NVARCHAR(255) NOT NULL,                       -- Departamento o estado donde est� ubicada la sucursal
	    broff_country NVARCHAR(255) NOT NULL,                     -- Pa�s donde est� ubicada la sucursal
	    
	    -- Contact Information
	    broff_phone NVARCHAR(255) NOT NULL,                       -- N�mero de tel�fono de la sucursal
	    broff_email NVARCHAR(255) NOT NULL,                       -- Direcci�n de correo electr�nico de la sucursal
	    
	    -- Status
	    broff_active BIT NOT NULL DEFAULT 1,                      -- Indica si la sucursal est� activa (1) o inactiva (0)
	
	    -- Unique constraint for company and branch code combination
	    CONSTRAINT UQ_Company_BranchCode UNIQUE (company_id, broff_code)
	);

-- Create EntityCatalog Table ---------------------------------------------------------------------------------------------------
	CREATE TABLE EntityCatalog (
	    -- Primary Key
	    id_entit INT IDENTITY(1,1) PRIMARY KEY,                    -- Identificador �nico para el elemento del cat�logo de entidades
	    
	    -- Entity Information
	    entit_name NVARCHAR(255) NOT NULL UNIQUE,                  -- Nombre del modelo Django asociado
	    entit_descrip NVARCHAR(255) NOT NULL,                      -- Descripci�n del elemento del cat�logo de entidades
	    
	    -- Status
	    entit_active BIT NOT NULL DEFAULT 1,                       -- Indica si el elemento del cat�logo est� activo (1) o inactivo (0)
	    
	    -- Configuration
	    entit_config NVARCHAR(MAX) NULL                           -- Configuraci�n adicional para el elemento del cat�logo
	);

-- Create Role Table ----------------------------------------------------------------------------------------
	CREATE TABLE Role (
	    -- Primary Key
	    id_role BIGINT IDENTITY(1,1) PRIMARY KEY,                 -- Identificador �nico para el rol
	    
	    -- Foreign Keys
	    company_id BIGINT NOT NULL                                -- Compa��a a la que pertenece este rol
	        CONSTRAINT FK_Role_Company 
	        FOREIGN KEY REFERENCES Company(id_compa),
	    
	    -- Basic Information
	    role_name NVARCHAR(255) NOT NULL,                         -- Nombre descriptivo del rol
	    role_code NVARCHAR(255) NOT NULL,                         -- C�digo del rol (agregado basado en unique_together)
	    role_description NVARCHAR(MAX) NULL,                      -- Descripci�n detallada del rol y sus responsabilidades
	    
	    -- Status
	    role_active BIT NOT NULL DEFAULT 1,                       -- Indica si el rol est� activo (1) o inactivo (0)
	    
	    -- Unique constraint for company and role code combination
	    CONSTRAINT UQ_Company_RoleCode UNIQUE (company_id, role_code)
	);
	
-- Create User Table ----------------------------------------------------------------------------------------------

	CREATE TABLE [User] (
	    -- Primary Key
	    id_user BIGINT IDENTITY(1,1) PRIMARY KEY,                 -- Identificador �nico para el usuario
	    
	    -- Authentication Information
	    user_username NVARCHAR(255) NOT NULL,                     -- Nombre de usuario para iniciar sesi�n
	    user_password NVARCHAR(255) NOT NULL,                     -- Contrase�a encriptada del usuario
	    
	    -- Contact Information
	    user_email NVARCHAR(255) NOT NULL,                        -- Direcci�n de correo electr�nico del usuario
	    user_phone NVARCHAR(255) NULL,                            -- N�mero de tel�fono del usuario
	    
	    -- Access Control
	    user_is_admin BIT NOT NULL DEFAULT 0,                     -- Indica si el usuario es Administrador (1) o normal (0)
	    user_is_active BIT NOT NULL DEFAULT 1,                    -- Indica si el usuario est� activo (1) o inactivo (0)
	    
	    -- Unique Constraints
	    CONSTRAINT UQ_User_Username UNIQUE (user_username),
	    CONSTRAINT UQ_User_Email UNIQUE (user_email)
	);

-- Create Permission Table ------------------------------------------------------------------------------------------
CREATE TABLE Permission (
    -- Primary Key
    id_permi BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso
    
    -- Basic Information
    name NVARCHAR(255) NOT NULL,                              -- Nombre descriptivo del permiso
    description NVARCHAR(MAX) NULL,                           -- Descripci�n detallada del permiso y su prop�sito
    
    -- CRUD Permissions
    can_create BIT NOT NULL DEFAULT 0,                        -- Permite crear nuevos registros
    can_read BIT NOT NULL DEFAULT 0,                          -- Permite ver registros existentes
    can_update BIT NOT NULL DEFAULT 0,                        -- Permite modificar registros existentes
    can_delete BIT NOT NULL DEFAULT 0,                        -- Permite eliminar registros existentes
    
    -- Data Transfer Permissions
    can_import BIT NOT NULL DEFAULT 0,                        -- Permite importar datos masivamente
    can_export BIT NOT NULL DEFAULT 0                         -- Permite exportar datos del sistema
);

-- Create PermiRole Table ----------------------------------------------------------------------------------------------
CREATE TABLE PermiRole (
    -- Primary Key
    id_perol BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de rol
    
    -- Foreign Keys
    role_id BIGINT NOT NULL                                   -- Rol al que se asigna el permiso
        CONSTRAINT FK_PermiRole_Role 
        FOREIGN KEY REFERENCES Role(id_role),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al rol
        CONSTRAINT FK_PermiRole_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id INT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiRole_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Permission Configuration
    perol_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el rol
    perol_record BIGINT NULL,                                 -- Campo mencionado en unique_together pero no en el modelo
    
    -- Unique constraint for role, permission, entity catalog, and record combination
    CONSTRAINT UQ_Role_Permission_Entity_Record 
        UNIQUE (role_id, permission_id, entitycatalog_id, perol_record)
);

-- Create PermiRoleRecord Table  --------------------------------------------------------------------------------
CREATE TABLE PermiRoleRecord (
    -- Primary Key
    id_perrc BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de rol por registro
    
    -- Foreign Keys
    role_id BIGINT NOT NULL                                   -- Rol al que se asigna el permiso
        CONSTRAINT FK_PermiRoleRecord_Role 
        FOREIGN KEY REFERENCES Role(id_role),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al rol
        CONSTRAINT FK_PermiRoleRecord_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id INT                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiRoleRecord_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Record Specific Information
    perrc_record BIGINT NOT NULL,                             -- Identificador del registro espec�fico al que se aplica el permiso
    
    -- Permission Configuration
    perrc_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el rol y registro
    
    -- Unique constraint for role, permission, entity catalog and record combination
    CONSTRAINT UQ_Role_Permission_Entity_Record2 
        UNIQUE (role_id, permission_id, entitycatalog_id, perrc_record)
);

-- Create UserCompany Table ----------------------------------------------------------------------------------------------------

CREATE TABLE UserCompany (
    -- Primary Key
    id_useco BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para la relaci�n usuario-compa��a
    
    -- Foreign Keys
    user_id BIGINT NOT NULL                                   -- Usuario asociado a la compa��a
        CONSTRAINT FK_UserCompany_User 
        FOREIGN KEY REFERENCES [User](id_user),
    
    company_id BIGINT NOT NULL                                -- Compa��a asociada al usuario
        CONSTRAINT FK_UserCompany_Company 
        FOREIGN KEY REFERENCES Company(id_compa),
    
    -- Status
    useco_active BIT NOT NULL DEFAULT 1,                      -- Indica si la relaci�n usuario-compa��a est� activa (1) o inactiva (0)
    
    -- Unique constraint for user and company combination
    CONSTRAINT UQ_User_Company UNIQUE (user_id, company_id)
);

-- Create PermiUser Table -----------------------------------------------------------------------------------------------------------------------
CREATE TABLE PermiUser (
    -- Primary Key
    id_peusr BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de usuario
    
    -- Foreign Keys
    usercompany_id BIGINT NOT NULL                            -- Relaci�n usuario-compa��a a la que se asigna el permiso
        CONSTRAINT FK_PermiUser_UserCompany 
        FOREIGN KEY REFERENCES UserCompany(id_useco),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al usuario
        CONSTRAINT FK_PermiUser_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id INT                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiUser_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Permission Configuration
    peusr_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el usuario
    
    -- Unique constraint for user-company, permission and entity catalog combination
    CONSTRAINT UQ_UserCompany_Permission_Entity 
        UNIQUE (usercompany_id, permission_id, entitycatalog_id)
);

-- Create PermiUserRecord Table  --------------------------------------------------------------------------------------------
CREATE TABLE PermiUserRecord (
    -- Primary Key
    id_peusr BIGINT IDENTITY(1,1) PRIMARY KEY,                -- Identificador �nico para el permiso de usuario
    
    -- Foreign Keys
    usercompany_id BIGINT NOT NULL                            -- Relaci�n usuario-compa��a a la que se asigna el permiso
        CONSTRAINT FK_PermiUserRecord_UserCompany 
        FOREIGN KEY REFERENCES UserCompany(id_useco),
        
    permission_id BIGINT NOT NULL                             -- Permiso asignado al usuario
        CONSTRAINT FK_PermiUserRecord_Permission 
        FOREIGN KEY REFERENCES Permission(id_permi),
        
    entitycatalog_id INT NOT NULL                          -- Entidad sobre la que se aplica el permiso
        CONSTRAINT FK_PermiUserRecord_EntityCatalog 
        FOREIGN KEY REFERENCES EntityCatalog(id_entit),
    
    -- Record Specific Information
    peusr_record BIGINT NOT NULL,                             -- Identificador del registro espec�fico de la entidad al que aplica el permiso
    
    -- Permission Configuration
    peusr_include BIT NOT NULL DEFAULT 1,                     -- Indica si el permiso se incluye (1) o se excluye (0) para el usuario
    
    -- Unique constraint for user-company, permission, entity catalog and record combination
    CONSTRAINT UQ_UserCompany_Permission_Entity_Record 
        UNIQUE (usercompany_id, permission_id, entitycatalog_id, peusr_record)
);

-- Create UserRole Table  --------------------------------------------------------------------------------------------------------

CREATE TABLE UserRole (
    UserRoleId INT PRIMARY KEY,
    UserId BIGINT,
    RoleId BIGINT,
    FOREIGN KEY (UserId) REFERENCES [User](id_user),
    FOREIGN KEY (RoleId) REFERENCES [Role](id_role)
);


-- Create EntityTableMap Table  --------------------------------------------------------------------------------------------------------

	CREATE TABLE EntityTableMap (
    entitycatalog_id INT PRIMARY KEY,
    table_name NVARCHAR(255),
    id_column_name NVARCHAR(255),
	entit_name NVARCHAR(255)
);

-------------------------------------------  INSERT ----------------------------------------------------------------------------

SELECT * FROM Company
-- Insertar compa��a
INSERT INTO Company (compa_name, compa_tradename, compa_doctype, compa_docnum, compa_address, compa_city, compa_state, compa_country, compa_industry, compa_phone, compa_email, compa_website, compa_logo, compa_active)
VALUES 
	  ('Banco Colpatria', 'Colpatria', 'NI', '8600345941', 'Cra 7 # 24-89', 'Bogota DC', 'Bogota DC', 'Colombia', 'Servicios Financieros', '7456300', 'contacto@colpatria.com', 'www.colpatria.com', NULL, 1);

SELECT * FROM BranchOffice
-- Insertar sucursal
INSERT INTO BranchOffice (company_id, broff_name, broff_code, broff_address, broff_city, broff_state, broff_country, broff_phone, broff_email, broff_active)
VALUES (1, 'Colpatria Norte ', 'Col-Norte', 'Av. Principal #101', 'Bogota DC', 'Bogota DC', 'Colombia', '555-1235', 'Col-Norte@Colpatria.com', 1),
       (1, 'Colpatria Sur', 'Col-Sur', 'Av. Principal #102', 'Bogota DC', 'Bogota DC', 'Colombia', '555-1256', 'Col-Sur@Colpatria.com', 1),
       (1, 'Colpatria Oriente', 'Col-Oriente', 'Av. Principal #103', 'Bogota DC', 'Bogota DC', 'Colombia', '555-9734', 'Col-Oriente@Colpatria.com', 1),
       (1, 'Colpatria Occidente', 'Col-Occidente', 'Av. Principal #100', 'Bogota DC', 'Bogota DC', 'Colombia', '555-1235', 'Col-Occidentel@Colpatria.com', 1);

-- Insertar centro de costo
SELECT * FROM CostCenter
INSERT INTO CostCenter (company_id, cosce_parent_id, cosce_code, cosce_name, cosce_description, cosce_budget, cosce_level, cosce_active)
VALUES 
      (1, NULL, 'CC-ADM', 'Administraci�n', 'Centro de costo para la administraci�n general del banco', 600000.00, 1, 1),
      (1, NULL, 'CC-FIN', 'Finanzas', 'Centro de costo para operaciones financieras', 800000.00, 1, 1),
      (1, NULL, 'CC-OPS', 'Operaciones', 'Centro de costo para operaciones de sucursales', 500000.00, 1, 1),
	  (1, 1, 'CC-ADM-ANL', 'An�lisis Adminstracion', 'Subcentro de costo para an�lisis de Administracion', 200000.00, 1, 1),
	  (1, 2, 'CC-FIN-PLN', 'Planificacion Financiera', 'Subcentro de costo para planificaci�n de recursos Financieros', 250000.00, 2, 1),
	  (1, 3, 'CC-OPS-CTR', 'Control Operaciones', 'Subcentro de costo para control de recursos Operacionales', 400000.00, 3, 1),
	  (1, 3, 'CC-OPS-RO', 'Reporte Operaciones', 'Subcentro de costo para Reporte de Operacionales', 600000.00, 3, 1);
	  (1, NULL, 'CC-VENT', 'Ventas', 'Centro de costo para Reporte de Ventas', 10000000.00, 1, 1);

	  -- Insertar permisos
select * from Permission
INSERT INTO Permission (name, description, can_create, can_read, can_update, can_delete, can_import, can_export)
VALUES 
    ('Permiso 1', 'Permisos: Ninguno', 0, 0, 0, 0, 0, 0),
    ('Permiso 2', 'Permisos: can_create', 1, 0, 0, 0, 0, 0),
    ('Permiso 3', 'Permisos: can_read', 0, 1, 0, 0, 0, 0),
    ('Permiso 4', 'Permisos: can_create, can_read', 1, 1, 0, 0, 0, 0),
    ('Permiso 5', 'Permisos: can_update', 0, 0, 1, 0, 0, 0),
    ('Permiso 6', 'Permisos: can_create, can_update', 1, 0, 1, 0, 0, 0),
    ('Permiso 7', 'Permisos: can_read, can_update', 0, 1, 1, 0, 0, 0),
    ('Permiso 8', 'Permisos: can_create, can_read, can_update', 1, 1, 1, 0, 0, 0),
    ('Permiso 9', 'Permisos: can_delete', 0, 0, 0, 1, 0, 0),
    ('Permiso 10', 'Permisos: can_create, can_delete', 1, 0, 0, 1, 0, 0),
    ('Permiso 11', 'Permisos: can_read, can_delete', 0, 1, 0, 1, 0, 0),
    ('Permiso 12', 'Permisos: can_create, can_read, can_delete', 1, 1, 0, 1, 0, 0),
    ('Permiso 13', 'Permisos: can_update, can_delete', 0, 0, 1, 1, 0, 0),
    ('Permiso 14', 'Permisos: can_create, can_update, can_delete', 1, 0, 1, 1, 0, 0),
    ('Permiso 15', 'Permisos: can_read, can_update, can_delete', 0, 1, 1, 1, 0, 0),
    ('Permiso 16', 'Permisos: can_create, can_read, can_update, can_delete', 1, 1, 1, 1, 0, 0),
    ('Permiso 17', 'Permisos: can_import', 0, 0, 0, 0, 1, 0),
    ('Permiso 18', 'Permisos: can_create, can_import', 1, 0, 0, 0, 1, 0),
    ('Permiso 19', 'Permisos: can_read, can_import', 0, 1, 0, 0, 1, 0),
    ('Permiso 20', 'Permisos: can_create, can_read, can_import', 1, 1, 0, 0, 1, 0),
    ('Permiso 21', 'Permisos: can_update, can_import', 0, 0, 1, 0, 1, 0),
    ('Permiso 22', 'Permisos: can_create, can_update, can_import', 1, 0, 1, 0, 1, 0),
    ('Permiso 23', 'Permisos: can_read, can_update, can_import', 0, 1, 1, 0, 1, 0),
    ('Permiso 24', 'Permisos: can_create, can_read, can_update, can_import', 1, 1, 1, 0, 1, 0),
    ('Permiso 25', 'Permisos: can_delete, can_import', 0, 0, 0, 1, 1, 0),
    ('Permiso 26', 'Permisos: can_create, can_delete, can_import', 1, 0, 0, 1, 1, 0),
    ('Permiso 27', 'Permisos: can_read, can_delete, can_import', 0, 1, 0, 1, 1, 0),
    ('Permiso 28', 'Permisos: can_create, can_read, can_delete, can_import', 1, 1, 0, 1, 1, 0),
    ('Permiso 29', 'Permisos: can_update, can_delete, can_import', 0, 0, 1, 1, 1, 0),
    ('Permiso 30', 'Permisos: can_create, can_update, can_delete, can_import', 1, 0, 1, 1, 1, 0),
    ('Permiso 31', 'Permisos: can_read, can_update, can_delete, can_import', 0, 1, 1, 1, 1, 0),
    ('Permiso 32', 'Permisos: can_create, can_read, can_update, can_delete, can_import', 1, 1, 1, 1, 1, 0),
    ('Permiso 33', 'Permisos: can_export', 0, 0, 0, 0, 0, 1),
    ('Permiso 34', 'Permisos: can_create, can_export', 1, 0, 0, 0, 0, 1),
    ('Permiso 35', 'Permisos: can_read, can_export', 0, 1, 0, 0, 0, 1),
    ('Permiso 36', 'Permisos: can_create, can_read, can_export', 1, 1, 0, 0, 0, 1),
    ('Permiso 37', 'Permisos: can_update, can_export', 0, 0, 1, 0, 0, 1),
    ('Permiso 38', 'Permisos: can_create, can_update, can_export', 1, 0, 1, 0, 0, 1),
    ('Permiso 39', 'Permisos: can_read, can_update, can_export', 0, 1, 1, 0, 0, 1),
    ('Permiso 40', 'Permisos: can_create, can_read, can_update, can_export', 1, 1, 1, 0, 0, 1),
    ('Permiso 41', 'Permisos: can_delete, can_export', 0, 0, 0, 1, 0, 1),
    ('Permiso 42', 'Permisos: can_create, can_delete, can_export', 1, 0, 0, 1, 0, 1),
    ('Permiso 43', 'Permisos: can_read, can_delete, can_export', 0, 1, 0, 1, 0, 1),
    ('Permiso 44', 'Permisos: can_create, can_read, can_delete, can_export', 1, 1, 0, 1, 0, 1),
    ('Permiso 45', 'Permisos: can_update, can_delete, can_export', 0, 0, 1, 1, 0, 1),
    ('Permiso 46', 'Permisos: can_create, can_update, can_delete, can_export', 1, 0, 1, 1, 0, 1),
    ('Permiso 47', 'Permisos: can_read, can_update, can_delete, can_export', 0, 1, 1, 1, 0, 1),
    ('Permiso 48', 'Permisos: can_create, can_read, can_update, can_delete, can_export', 1, 1, 1, 1, 0, 1),
    ('Permiso 49', 'Permisos: can_import, can_export', 0, 0, 0, 0, 1, 1),
    ('Permiso 50', 'Permisos: can_create, can_import, can_export', 1, 0, 0, 0, 1, 1),
    ('Permiso 51', 'Permisos: can_read, can_import, can_export', 0, 1, 0, 0, 1, 1),
    ('Permiso 52', 'Permisos: can_create, can_read, can_import, can_export', 1, 1, 0, 0, 1, 1),
    ('Permiso 53', 'Permisos: can_update, can_import, can_export', 0, 0, 1, 0, 1, 1),
    ('Permiso 54', 'Permisos: can_create, can_update, can_import, can_export', 1, 0, 1, 0, 1, 1),
    ('Permiso 55', 'Permisos: can_read, can_update, can_import, can_export', 0, 1, 1, 0, 1, 1),
    ('Permiso 56', 'Permisos: can_create, can_read, can_update, can_import, can_export', 1, 1, 1, 0, 1, 1),
    ('Permiso 57', 'Permisos: can_delete, can_import, can_export', 0, 0, 0, 1, 1, 1),
    ('Permiso 58', 'Permisos: can_create, can_delete, can_import, can_export', 1, 0, 0, 1, 1, 1),
    ('Permiso 59', 'Permisos: can_read, can_delete, can_import, can_export', 0, 1, 0, 1, 1, 1),
    ('Permiso 60', 'Permisos: can_create, can_read, can_delete, can_import, can_export', 1, 1, 0, 1, 1, 1),
    ('Permiso 61', 'Permisos: can_update, can_delete, can_import, can_export', 0, 0, 1, 1, 1, 1),
    ('Permiso 62', 'Permisos: can_create, can_update, can_delete, can_import, can_export', 1, 0, 1, 1, 1, 1),
    ('Permiso 63', 'Permisos: can_read, can_update, can_delete, can_import, can_export', 0, 1, 1, 1, 1, 1),
    ('Permiso 64', 'Permisos: can_create, can_read, can_update, can_delete, can_import, can_export', 1, 1, 1, 1, 1, 1);

-- Insertar roles
select * from Role
INSERT INTO Role (company_id, role_name, role_code, role_description, role_active)
VALUES (1, 'Gerente', 'GERENTE', 'Responsable de la administraci�n Comercial de la sucursal', 1),
       (1, 'Director', 'DIRECTOR', 'Responsable de la administraci�n Operativa de la sucursal', 1),
       (1, 'Asesor', 'ASESOR', 'Responsable de las ventas diarias', 1),
       (1, 'Cajero', 'CAJERO', 'Responsable de las transacciones diarias', 1),
	   (1, 'Cajero Principal', 'CAJERO PRINCIPAL', 'Responsable de las transacciones diarias y cuadre contable de la oficina', 1);

-- Insertar usuarios
select * from [User]
INSERT INTO [User] (user_username, user_password, user_email, user_phone, user_is_admin, user_is_active)
VALUES
    ('Alejandro Gomez', 'password123!Jd', 'jdoe@mail.com', '123-456-7890', 1, 1),
    ('Diana Franco', 'securePass45@As', 'asmith@mail.com', '234-567-8901', 1, 1),
    ('Oliver Lopez', 'mJoNes2023*', 'mjones@mail.com', '345-678-9012', 0, 1),
    ('Paola Vivas', 'rr0driGueZ#44', 'rrodriguez@mail.com', '456-789-0123', 0, 1),
    ('Lorena Rico', 'bH4rri5$Secure', 'bharris@mail.com', '567-890-1234', 1, 1),
    ('Andres Perez', 'wC1ark@2024$', 'wclark@mail.com', '678-901-2345', 1, 1),
    ('Marylin Contreras', 'nMartinez^9', 'nmartinez@mail.com', '789-012-3456', 0, 1),
    ('Fanny Gutierrez', 'eg0nza12LeS$', 'egonzalez@mail.com', NULL, 0, 1),
    ('Carolina Vargas', 'wilsoN!2023^', 'jwilson@mail.com', NULL, 1, 1),
    ('Julian Otalora', 'MurphySecure!@9', 'mmurphy@mail.com', '123-456-7890', 1, 1),
    ('Jhoana Arbelaez', 'Ort1z$Great', 'eortiz@mail.com', NULL, 0, 1),
    ('Edgar Barriga', 'aGr@y$secure55', 'agray@mail.com', '234-567-8901', 0, 1),
    ('Francia Rincon', 'rH1LL^safe90', 'rhill@mail.com', '345-678-9012', 1, 1),
    ('Monica Riano', 'DD@v1s_2023', 'ddavis@mail.com', NULL, 1, 1),
    ('Laura Benjumea', 'BmoorE$Pass88', 'bmoore@mail.com', '456-789-0123', 0, 1),
    ('Karina Ayala', 'LeeSecure^2023!', 'jlee@mail.com', '567-890-1234', 0, 1),
	('Jhonatan Escobar', 'Jhonatan^2023!', 'Jhonatan@mail.com', '589-890-1234', 0, 1),
	('Fernando Torres', 'Fernando^2023!', 'Fernando@mail.com', '534-890-1234', 0, 1),
	('Tatiana Rojas', 'Tatiana^2023!', 'Tatiana@mail.com', '511-890-1234', 0, 1),
	('Sandra Villamil', 'Sandra^2023!', 'Sandra@mail.com', '521-890-1234', 0, 1),
	('Lorena Zapata', 'Lorena^2023!', 'Lorena@mail.com', '221-890-3234', 0, 1),
	('Sebastian Monroy', 'Sebastian^2023!', 'Sebastian@mail.com', '121-990-1234', 0, 1),
	('Yamile Ruiz', 'Yamile^2023!', 'Yamile@mail.com', '621-890-4834', 0, 1),
	('Natalia Guzman', 'Natalia^2023!', 'Natalia@mail.com', '721-850-1234', 0, 1);

-- Insertar usuarios en compa�ias

select * from UserCompany
INSERT INTO UserCompany (user_id, company_id, useco_active)
VALUES
		(1,1,1),
		(2,1,1),
		(3,1,1),
		(4,1,1),
		(5,1,1),
		(6,1,1),
		(7,1,1),
		(8,1,1),
		(9,1,1),
		(10,1,1),
		(11,1,1),
		(12,1,1),
		(13,1,1),
		(14,1,1),
		(15,1,1),
		(16,1,1),
		(17,1,1),
		(18,1,1),
		(19,1,1),
		(20,1,1),
		(21,1,1),
		(22,1,1),
		(23,1,1),
		(24,1,1);

-- Insertar catalogo de entidades 

select * from EntityCatalog

INSERT INTO EntityCatalog (entit_name, entit_descrip, entit_active, entit_config)
VALUES 
	('BranchOffice', 'Sucursal dentro de una compa��a', 1, NULL),
	('Company', 'Compa��a o entidad jur�dica', 1, NULL),
	('CostCenter', 'Centro de costo dentro de una compa��a', 1, NULL),
	('Role', 'Rol asignado a un usuario dentro de la compa��a', 1, NULL),
	('User', 'Usuario dentro del sistema', 1, NULL),
	('UserCompany', 'Relaci�n entre un usuario y la compa��a', 1, NULL),
	('Permission', 'Permisos asignados a roles o usuarios', 1, NULL),
	('PermiRole', 'Permisos asignados a un rol', 1, NULL),
	('PermiUser', 'Permisos asignados a un usuario', 1, NULL),
	('PermiRoleRecord', 'Permisos asignados a un rol para un registro espec�fico', 1, NULL),
	('PermiUserRecord', 'Permisos asignados a un usuario para un registro espec�fico', 1, NULL);


-- Asignar permisos a los roles

select * from PermiRole
INSERT INTO PermiRole (role_id, permission_id, entitycatalog_id, perol_include, perol_record) VALUES
(1, 64, 1, 1, NULL),  
(1, 64, 2, 1, NULL),  
(1, 64, 3, 1, NULL),  
(1, 64, 4, 1, NULL),  
(1, 64, 5, 1, NULL),  
(1, 64, 6, 1, NULL),  
(1, 64, 7, 1, NULL),  
(1, 64, 8, 1, NULL),  
(1, 64, 9, 1, NULL),  
(1, 64, 10, 1, NULL), 
(1, 64, 11, 1, NULL), 
(2, 32, 1, 1, NULL),  
(2, 32, 2, 1, NULL),  
(2, 32, 3, 1, NULL),  
(2, 32, 4, 1, NULL),  
(2, 32, 5, 1, NULL),  
(2, 32, 6, 1, NULL),  
(2, 32, 7, 1, NULL),  
(2, 32, 8, 1, NULL),  
(2, 32, 9, 0, NULL),  
(2, 32, 10, 0, NULL), 
(2, 32, 11, 0, NULL), 
(3, 8, 1, 1, NULL),  
(3, 8, 2, 1, NULL), 
(3, 8, 3, 1, NULL), 
(3, 8, 4, 1, NULL), 
(3, 8, 5, 1, NULL), 
(3, 8, 6, 0, NULL), 
(3, 8, 7, 0, NULL), 
(3, 8, 8, 0, NULL), 
(3, 8, 9, 0, NULL), 
(3, 8, 10, 0, NULL),
(3, 8, 11, 0, NULL),
(4, 6, 1, 1, NULL), 
(4, 6, 2, 1, NULL), 
(4, 6, 3, 0, NULL), 
(4, 6, 4, 1, NULL), 
(4, 6, 5, 0, NULL), 
(4, 6, 6, 0, NULL), 
(4, 6, 7, 0, NULL), 
(4, 6, 8, 0, NULL), 
(4, 6, 9, 0, NULL), 
(4, 6, 10, 0, NULL),
(4, 6, 11, 0, NULL),
(5, 6, 1, 1, NULL), 
(5, 6, 2, 1, NULL), 
(5, 6, 3, 0, NULL), 
(5, 6, 4, 1, NULL), 
(5, 6, 5, 0, NULL), 
(5, 6, 6, 0, NULL), 
(5, 6, 7, 0, NULL), 
(5, 6, 8, 0, NULL), 
(5, 6, 9, 0, NULL), 
(5, 6, 10, 0, NULL),
(5, 6, 11, 0, NULL)

-- Inserciones en PermiRoleRecord para los roles de la tabla Role con permisos espec�ficos sobre EntityCatalog
select * from PermiRoleRecord

INSERT INTO PermiRoleRecord (role_id, permission_id, entitycatalog_id, perrc_record, perrc_include)
VALUES 
	(5, 3, 3, 4, 1),
	(5, 3, 3, 5, 1),
	(5, 3, 3, 6, 1),
	(5, 3, 3, 7, 1);

-- Asignar permisos a los usuarios
select * from PermiUser
	INSERT INTO PermiUser (usercompany_id, permission_id, entitycatalog_id, peusr_include) VALUES
	-- Permisos adicionales para la entidad BranchOffice (Sucursal)
	(3, 3, 3, 0),
	(7, 3, 3, 0),
	(11, 3, 3, 0),
	(22, 3, 3, 0);


-- Inserciones en PermiUserRecord para los usuarios de la tabla user con permisos espec�ficos sobre EntityCatalog
select * from PermiUserRecord
INSERT INTO PermiUserRecord (usercompany_id, permission_id, entitycatalog_id, peusr_record, peusr_include)
VALUES
    (3, 8, 3, 8, 1), 
	(7, 8, 3, 8, 1),
	(11,8, 3, 8, 1),
	(22,8, 3, 8,1);

select * from UserRole
INSERT INTO UserRole (UserRoleId,UserId,RoleId)
VALUES 
	(1,1,1),
	(2,2,2),
	(3,3,3),
	(4,4,5),
	(5,5,1),
	(6,6,2),
	(7,7,3),
	(8,8,5),
	(9,9,1),
	(10,10,2),
	(11,11,3),
	(12,12,5),
	(13,13,1),
	(14,14,2),
	(15,15,3),
	(16,16,4),
	(17,17,5),
	(18,18,4),
	(19,19,4),
	(20,20,4),
	(21,21,3),
	(22,22,3),
	(23,23,3),
	(24,24,3);


---- EntityTableMap tabla para el mapeo de las entidades

select * from EntityTableMap

	INSERT INTO EntityTableMap (entitycatalog_id, table_name, id_column_name,entit_name)
VALUES 
    (1, 'BranchOffice', 'id_broff','BranchOffice'),       
    (2, 'Company', 'id_compa','Company'),                 
    (3, 'CostCenter', 'id_cosce','CostCenter'),           
    (4, 'EntityCatalog', 'id_entit','EntityCatalog'),     
    (5, 'PermiRole', 'id_perol','PermiRole'),             
    (6, 'PermiRoleRecord', 'id_perrc','PermiRoleRecord'), 
    (7, 'Permission', 'id_permi','Permission'),           
    (8, 'PermiUser', 'id_peusr','PermiUser'),            
    (9, 'PermiUserRecord', 'id_peusr','PermiUserRecord'), 
    (10, 'Role', 'id_role','Role'), 
    (11, 'User', 'id_user','User'), 
    (12, 'UserCompany', 'id_useco','UserCompany'),        
    (13, 'UserRole', 'UserRoleId','UserRole'),            
      
---- querys ------------------------------------------------------------

---- Company
	select * from Company

----- BranchOffice

	select id_broff,broff_name, compa_name 
	from BranchOffice b
	join Company c on c.id_compa = b.company_id 

----- CostCenter

	select id_cosce,compa_name,cosce_parent_id,cosce_code,cosce_name,cosce_description,cosce_budget,cosce_level,cosce_active
	from CostCenter
	join Company c on c.id_compa = company_id

--- EntityCatalog
	select * from EntityCatalog

-- permission
	select * from Permission

--- Role
	select id_role,role.role_description,compa_name,role_code
	from role
	join Company c on c.id_compa = company_id

--- permirole
	select id_perol,role_name,name,description,entit_name,entit_descrip,perol_include 
	from permirole p
	join role r on r.id_role = p.role_id
	join Permission per on per.id_permi = p.permission_id
	join EntityCatalog e on e.id_entit = p.entitycatalog_id

--- permirolerecord
	select id_perrc,role_name,name,description,entit_name,entit_descrip,perrc_include,perrc_record,perrc_include
	from permirolerecord p
	join role r on r.id_role = p.role_id
	join Permission per on per.id_permi = p.permission_id
	join EntityCatalog e on e.id_entit = p.entitycatalog_id

-- permiuser
	select id_user,id_peusr,user_username,name,description,entit_name,entit_descrip,peusr_include 
	from permiuser
	join usercompany u on u.id_useco  = usercompany_id
	join [user] us on us.id_user = u.USER_ID
	join Permission p on p.id_permi = permission_id
	join EntityCatalog e on e.id_entit = entitycatalog_id
	
-- 	permiuserrecord
	select id_user,id_peusr,user_username,name,description,entit_name,entit_descrip,peusr_record,peusr_include
	from PermiUserRecord
	join usercompany u on u.id_useco  = usercompany_id
	join [user] us on us.id_user = u.USER_ID
	join Permission p on p.id_permi = permission_id
	join EntityCatalog e on e.id_entit = entitycatalog_id

	-- ejecucion de Store Procedure

	exec sp_ObtenerPermisosUsuarioPorEntidad3 3,3 -- POR USUARIO (@id_user,@id_entit)
	exec sp_ObtenerPermisosUsuarioPorEntidad3 4,3 -- --- POR GRUPO (@id_user,@id_entit)

	