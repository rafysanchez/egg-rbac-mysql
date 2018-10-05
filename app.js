'use strict';

const menus = require('./lib/menus');

module.exports = app => {
  if (app.config.mysql.client) menus(app);
  app.config.coreMiddleware.push('rbac');
};
