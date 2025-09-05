/**
 * Splits a string of SQL commands into an array of individual statements.
 * This function correctly handles the `DELIMITER` command, which we use when
 * creating stored procedures
 * @param {string} sqlString The full string of SQL commands.
 * @returns {Array<string>} An array of individual SQL statements.
 */
module.exports = function splitSqlByDelimiter(sqlString) {
   // Normalize line endings to a single character for consistent splitting
   const normalizedSql = sqlString.replace(/\r\n/g, "\n").replace(/\r/g, "\n");
   const lines = normalizedSql.split("\n");
   let delimiter = ";";
   let currentStatement = "";
   const statements = [];

   for (const line of lines) {
      const trimmedLine = line.trim();

      // Check for a DELIMITER command at the beginning of the line.
      const delimiterMatch = trimmedLine.match(/^DELIMITER\s+(.*)/i);
      if (delimiterMatch) {
         delimiter = delimiterMatch[1];
         // Skip this line because it's not part of a command
         continue;
      }
      currentStatement += line;

      if (currentStatement.endsWith(delimiter)) {
         statements.push(
            currentStatement
               .substring(0, currentStatement.length - delimiter.length)
               .trim()
         );
         currentStatement = "";
      } else {
         currentStatement += "\n";
      }
   }

   // The currentStatement should be empty, but for safety, let's include it
   if (currentStatement.trim() !== "") {
      statements.push(currentStatement.trim());
   }

   return statements;
}
