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
    app.menuPermission = await client.query('select sm.id menu_id, sm.parent_id menu_parent_id, sm.path menu_path, sp.id permission_id from sys_menu sm left join sys_permission sp on sp.permission = sm.id and sp.type="0";');
    const headerMenu = await client.query('select sm.id menu_id, sm.parent_id menu_parent_id, sm.name menu_name, sm.path menu_path, sm.icon menu_icon, sp.id permission_id, sp.name permission_name, sm.sort from sys_menu sm left join sys_permission sp on sp.permission = sm.id and sp.type="0" where sm.parent_id = "-1" order by sm.sort;');
    const siderMenu = await client.query('select sm.id menu_id, sm.parent_id menu_parent_id, sm.name menu_name, sm.path menu_path, sm.icon menu_icon, sp.id permission_id, sp.name permission_name, sm.sort from sys_menu sm left join sys_permission sp on sp.permission = sm.id and sp.type="0" where sm.parent_id != "-1";');
    for(const header of headerMenu){
      addMenu(siderMenu, header)
    }
    app.menus = headerMenu;
  });

  function addMenu(menus, parent){
    const copyMenus = menus.concat();
    for(const child of menus){
      const parentArray = child.menu_parent_id.split(',');
      if(parentArray[parentArray.length-1] == parent.menu_id){
        let tmp = new Set();
        let tmpArray = parent.sub_menu;
        if(typeof (parent.sub_menu) !== 'undefined'){
          tmp = new Set(tmpArray);
        }
        tmp.add(child);
        parent.sub_menu = Array.from(tmp);
        
        copyMenus.splice(copyMenus.findIndex((element) => {
          return element.menu_id === child.menu_id;
        }), 1);
        addMenu(copyMenus, child);
      }
    }
  }
};
