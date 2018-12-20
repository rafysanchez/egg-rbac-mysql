'use strict';

module.exports = options => {
    return async function rbac(ctx, next) {
        ctx.locals.menus = ctx.app.collapseMenus;
        if (ctx.path.endsWith('/') && ctx.path !== '/') {
            ctx.path = ctx.path.slice(0, -1);
        }
        if (ctx.path.match(options.matchPattern) !== null && !options.escapeUrl.includes(ctx.path)) {
            const result = await checkPermission(ctx.session.user, ctx.path, ctx.app.permissions, ctx.app.menus.concat(ctx.app.operations));
            if (typeof result === 'number') {
                ctx.status = result;
            } else if (typeof result === 'boolean' && result) {
                await next();
            } else {
                ctx.locals.onMenu = result;
                await next();
            }
        } else {
            await next();
        }
    };

    async function checkPermission(user, path, permissions, fullMO) {
        if (!user) {
            return 401;
        }

        const uuidReg = /[0-9a-z]{8}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{4}-[0-9a-z]{12}/;
        const tmp_path = path.replace(uuidReg, '$');

        let userMO = [];
        for (const role of user.roles) {
            userMO = userMO.concat(permissions[role].menu);
            userMO = userMO.concat(permissions[role].operation);
        }
        userMO = Array.from(new Set(userMO));
        user.permissions = userMO;

        // for (const item of fullMO) {
        //   if (tmp_path === item.path && userMO.includes(item.id)) {
        //     if (typeof item.type === 'undefined') {
        //       return true;
        //     } else if (item.type === 2) {
        //       return {
        //         id: item.parent_id.split(',')[2],
        //         hid: item.parent_id.split(',')[1],
        //       };
        //     }
        //     return {
        //       id: item.id,
        //       hid: item.parent_id === '-1' ? item.id : item.parent_id.split(',')[1],
        //     };
        //   }
        // }

        let exsitMO = null;
        for (const item of fullMO) {
            if (tmp_path === item.path) {
                exsitMO = item;
                break;
            }
        }
        if (exsitMO === null) {
            return 404;
        }

        if (userMO.includes(exsitMO.id)) {
            if (typeof exsitMO.type === 'undefined') {
                return true;
            } else if (exsitMO.type === 2) {
                return {
                    id: exsitMO.parent_id.split(',')[2],
                    hid: exsitMO.parent_id.split(',')[1],
                };
            }
            return {
                id: exsitMO.id,
                hid: exsitMO.parent_id === '-1' ? exsitMO.id : exsitMO.parent_id.split(',')[1],
            };
        }

        return 403;
    }
};
