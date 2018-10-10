'use strict';

module.exports = options => {
    return async function rbac(ctx, next) {
        if (ctx.path.endsWith('/') && ctx.path !== '/') {
            ctx.path = ctx.path.substring(0, ctx.path.length - 1);
        }
        if (ctx.path.match(options.matchPattern) !== null && !options.escapeUrl.includes(ctx.path)) {
            const result = await checkPermission(ctx.session.user, ctx.path, ctx.app.liteMenu)
            if (result === null) {
                ctx.status = 404;
            } else if (result === 401) {
                // ctx.status = 401;
                await next();
            } else if (result) {
                await next();
            } else {
                ctx.status = 200;
                return await ctx.render(options.errorPage, options.errorMessage);
            }
        } else {
            await next();
        }
    };

    async function checkPermission(user, path, menus) {
        let onMenu = null;
        for (const menu of menus) {
            if (path === menu.menu_path) {
                onMenu = menu;
                break;
            }
        }
        if (onMenu === null) {
            return null
        };
        if (!user) {
            return 401;
        }
        return user.permissions.includes(onMenu.menu_id);
    }
};