'use strict';

module.exports = options => {
  return async function rbac(ctx, next) {
    if(ctx.path.endsWith('/')){
        ctx.path = ctx.path.substring(0,ctx.path.length-1);
    }
    if(typeof(options.matchPattern) !== 'undefined'){
        if(ctx.path.match(options.matchPattern)!==null && !options.escapeUrl.includes(ctx.path)){
            const result = await checkPermission(ctx.session.user, ctx.path, ctx.app.menuPermission)
            if(result){
                await next();
            }else{
                ctx.status = 200;
                return await ctx.render(options.errorPage, options.errorMessage);
            }
        }else{
            await next();
        }
    }else{
        if(await checkPermission(ctx.session.user, ctx.path, ctx.app.menuPermission)){
            await next();
        }else{
            ctx.status = 200;
            return await ctx.render(options.errorPage, options.errorMessage);
        }
    }
  };

  async function checkPermission(user, path, menuPermission){
    let menuPermissionId = '';
    for(const menu of menuPermission){
        if(path === menu.menu_path){
            menuPermissionId = menu.permission_id;
            break;
        }
    }
    if(menuPermissionId === '') {return false};
    let menuPermissionAuth = false;
    for(const role of user.roles){
        for(const permission of role.permissions){
            if(menuPermissionId === permission.id){
                menuPermissionAuth = true;
                break;
            }
        }
    }
    return menuPermissionAuth;
  }
};