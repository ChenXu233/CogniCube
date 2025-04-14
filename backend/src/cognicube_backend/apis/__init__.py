from .router_manage import RouterManager
from .v1.admin import admin
from .v1.auth import auth
from .v1.conversation import ai
from .v1.expression import expression
from .v1.signup import signup
from .v1.statistics import statistics

router_manager = RouterManager()
router_manager.add_routers([auth, signup, expression, ai, admin, statistics])
