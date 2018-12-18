'use strict';
const assert = require('assert');
const rds = require('ali-rds');

module.exports = app => {
  const { mysql } = app.config;
  assert(
      mysql && mysql.client && mysql.client.host && mysql.client.port && mysql.client.user && mysql.client.database,
      'mysql are required on config'
  );
  // 创建实例
  const client = rds(mysql.client);

  // 做启动应用前的检查
  app.beforeStart(async () => {
    // 构造完整菜单
    const headerMenu = await client.query('select * from sys_menu m where m.type = 0 order by sort;');
    const siderMenu = await client.query('select * from sys_menu m where m.type = 1 or m.type =2 order by sort;');
    app.menus = await client.query('select * from sys_menu order by sort;');
    for (const header of headerMenu) {
      addMenu(siderMenu, header);
    }
    app.collapseMenus = headerMenu;
    // 构造完整操作
    app.operations = await client.query('select * from sys_operation order by sort;');

    const permissions = new Map();
    // 构造role-permission-menu
    const rpm = await client.query('select r.id, r.name role, r.enable, m.id mid, m.parent_id mpid, m.name, m.type, m.path, m.icon, m.sort from sys_role r, sys_role_permission rp, sys_permission p, sys_menu m where r.id = rp.role_id and rp.permission_id = p.id and p.f_id = m.id and p.type = 0 order by m.sort;');
    for (const menu of rpm) {
      if (menu.enable === 'T') {
        const roleMenu = permissions.has(menu.id) ? permissions.get(menu.id) : { menu: [] };
        const menuSet = new Set(roleMenu.menu);
        menuSet.add(menu.mid);
        roleMenu.menu = Array.from(menuSet);
        permissions.set(menu.id, roleMenu);
      }
    }

    // 构造role-permission-operation
    const rpo = await client.query('select r.id, r.name role, r.enable, o.id oid, o.name, o.path, o.icon, o.sort from sys_role r, sys_role_permission rp, sys_permission p, sys_operation o where r.id = rp.role_id and rp.permission_id = p.id and p.f_id = o.id and p.type = 1 order by o.sort;');
    for (const operation of rpo) {
      if (operation.enable === 'T') {
        const roleOperation = permissions.has(operation.id) ? permissions.get(operation.id) : { operation: [] };
        const operationSet = new Set(roleOperation.operation);
        operationSet.add(operation.oid);
        roleOperation.operation = Array.from(operationSet);
        permissions.set(operation.id, roleOperation);
      }
    }
    const permissionsObj = Object.create(null);
    for (const [ k, v ] of permissions) {
      permissionsObj[k] = v;
    }
    app.permissions = permissionsObj;
  });
};

function addMenu(menus, parent) {
  const copyMenus = Array.from(menus);
  for (const child of menus) {
    const parentArray = child.parent_id.split(',');
    // 判断子菜单中最后一个上级菜单是否是当前传入的parent，如果是将该菜单加入到parent.sub_menu中
    if (parentArray[parentArray.length - 1] === parent.id) {
      let tmp = new Set();
      const tmpArray = parent.sub_menu;
      if (typeof (parent.sub_menu) !== 'undefined') {
        tmp = new Set(tmpArray);
      }
      tmp.add(child);
      parent.sub_menu = Array.from(tmp);

      // 从复制的菜单中删除已经加入的子菜单，并再复制菜单中查找子菜单的子菜单
      copyMenus.splice(copyMenus.findIndex(element => {
        return element.id === child.id;
      }), 1);
      addMenu(copyMenus, child);
    }
  }
}
