'use strict';
/**
 * 相当于在egg.onerror前面封了一层
 * 是对数据库的权限判断，与egg.onerror不冲突
 * @param {*} options matchPattern, escapeUrl, homePage, errorPage
 * @returns
 */
module.exports = options => {
    return async function rbac(ctx, next) {
        ctx.locals.menus = ctx.app.collapseMenus;
        if (ctx.path.endsWith('/') && ctx.path !== '/') {
            ctx.path = ctx.path.slice(0, -1);
        }
        if (typeof options.homePage !== 'undefined') {
            options.escapeUrl.push(options.homePage);
        }
        if (typeof options.errorPage !== 'undefined') {
            options.escapeUrl.push(options.errorPage);
        }
        if (ctx.path.match(options.matchPattern) !== null && !options.escapeUrl.includes(ctx.path)) {
            const result = await checkPermission(ctx.session.user, ctx.path, ctx.app.permissions, ctx.app.menus.concat(ctx.app.operations));
            if (typeof result === 'number') {
                // 当用户不存在，重定向home页面
                if (result === 401) {
                    return ctx.redirect(options.homePage);
                }
                // 当用户没有权限403，或者，数据库中未配置对应权限404，渲染异常页面
                const error = {
                    code: result,
                    msg: {
                        403: '没有操作权限',
                        404: '页面走丢了',
                    }[result],
                };
                ctx.status = 200;
                return await ctx.render(options.errorPage, { error });
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
