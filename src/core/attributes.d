/**
* Copyright © DiamondMVC 2017
* License: MIT (https://github.com/DiamondMVC/Diamond-db/blob/master/LICENSE)
* Author: Jacob Jensen (bausshf)
*/
module diamond.database.core.attributes;

/// Attribute for excluding fields.
struct DbNoMap { }

/// Attribute for marking fields as nullable.
struct DbNull { }

/// Attribute for marking fields as db-enums.
struct DbEnum { }

/// Attribute for ids.
struct DbId { }

/// Attribute for timestamps.
struct DbTimestamp { }
