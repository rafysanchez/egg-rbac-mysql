'use strict';

const mock = require('egg-mock');

describe('test/rbac-mysql.test.js', () => {
  let app;
  before(() => {
    app = mock.app({
      baseDir: 'apps/rbac-mysql-test',
    });
    return app.ready();
  });

  after(() => app.close());
  afterEach(mock.restore);

  it('should GET /', () => {
    return app.httpRequest()
      .get('/')
      .expect('hi, rbac')
      .expect(200);
  });
});
