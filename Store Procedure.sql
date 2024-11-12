ALTER PROCEDURE [dbo].[sp_ObtenerPermisosUsuarioPorEntidad3]
    @id_user INT,
    @id_entit INT
AS
BEGIN
    CREATE TABLE #UserPermissions (
        usuario INT,
        descripcion VARCHAR(255),
        entidad VARCHAR(255),
        elementoEntidad VARCHAR(255),
        mensaje VARCHAR(255),
        PriorityLevel NVARCHAR(100)
    );

    DECLARE @table_name NVARCHAR(255);
    DECLARE @id_column_name NVARCHAR(255);
    DECLARE @entit_name VARCHAR(255);
    DECLARE @sql NVARCHAR(MAX);

    -- Obtiene el nombre de la tabla y la columna del ID para la entidad
    SELECT 
        @table_name = table_name,
        @id_column_name = id_column_name,
        @entit_name = entit_name
    FROM EntityTableMap
    WHERE entitycatalog_id = @id_entit;

    -- Verifica que se haya encontrado la tabla de referencia
    IF @table_name IS NULL OR @id_column_name IS NULL OR @entit_name IS NULL
    BEGIN
        RAISERROR('No se encontró una tabla correspondiente para la entidad especificada.', 16, 1);
        RETURN;
    END

    -- Construye la consulta para permisos de usuario
    SET @sql = N'
        INSERT INTO #UserPermissions (usuario, descripcion, entidad, elementoEntidad, mensaje, PriorityLevel)
        SELECT 
            uc.id_useco AS usuario,
            p.description AS descripcion,
            @entit_name AS entidad, -- Usar la variable para el nombre de la entidad
            cc.' + QUOTENAME(@id_column_name) + ' AS elementoEntidad,
            ''Permiso asignado al usuario '' + u.user_username AS mensaje,
            ''1'' AS PriorityLevel
        FROM PermiUserRecord pur
        INNER JOIN Permission p ON pur.permission_id = p.id_permi
        INNER JOIN UserCompany uc ON pur.usercompany_id = uc.id_useco
        INNER JOIN [User] u ON u.id_user = uc.user_id
        INNER JOIN ' + QUOTENAME(@table_name) + ' cc ON cc.' + QUOTENAME(@id_column_name) + ' = pur.peusr_record
        WHERE uc.user_id = @id_user AND pur.entitycatalog_id = @id_entit;
    ';

    -- Ejecuta la consulta dinámica para permisos de usuario
    EXEC sp_executesql @sql, N'@id_user INT, @id_entit INT, @entit_name VARCHAR(255)', @id_user, @id_entit, @entit_name;

    -- Verifica si no hay permisos de usuario (Nivel 1)
    IF NOT EXISTS (SELECT 1 FROM #UserPermissions WHERE PriorityLevel = '1')
    BEGIN
        -- Construye la consulta para permisos de rol
        SET @sql = N'
            INSERT INTO #UserPermissions (usuario, descripcion, entidad, elementoEntidad, mensaje, PriorityLevel)
            SELECT 
                r.UserId AS usuario,
                p.description AS descripcion,
                @entit_name AS entidad, -- Usar la variable para el nombre de la entidad
                cc.' + QUOTENAME(@id_column_name) + ' AS elementoEntidad,
                ''Permiso asignado al rol de '' + ro.role_name AS mensaje,
                ''2'' AS PriorityLevel
            FROM PermiRoleRecord prr
            INNER JOIN Permission p ON prr.permission_id = p.id_permi
            INNER JOIN UserRole r ON prr.role_id = r.RoleId
            INNER JOIN [Role] ro ON ro.id_role = r.RoleId
            INNER JOIN ' + QUOTENAME(@table_name) + ' cc ON cc.' + QUOTENAME(@id_column_name) + ' = prr.perrc_record
            WHERE r.UserId = @id_user AND prr.entitycatalog_id = @id_entit;
        ';

        -- Ejecuta la consulta dinámica para permisos de rol
        EXEC sp_executesql @sql, N'@id_user INT, @id_entit INT, @entit_name VARCHAR(255)', @id_user, @id_entit, @entit_name;
    END

    -- Selecciona los permisos ordenados por nivel de prioridad
    SELECT usuario, descripcion, entidad, elementoEntidad, mensaje
    FROM #UserPermissions
    ORDER BY PriorityLevel;

    -- Limpia la tabla temporal
    DROP TABLE #UserPermissions;
END;
