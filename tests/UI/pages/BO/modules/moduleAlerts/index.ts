import {ModuleManager} from '@pages/BO/modules/moduleManager';

/**
 * Module manager page, contains selectors and functions for the page
 * @class
 * @extends BOBasePage
 */
class ModuleAlerts extends ModuleManager {
  constructor() {
    super();

    this.pageTitle = `Module notifications • ${global.INSTALL.SHOP_NAME}`;
  }
}

export default new ModuleAlerts();
