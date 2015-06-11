%module kiwi 
 %{
 /* Includes the header in the wrapper code */
 #include "../kiwi/row.h"
 #include "../kiwi/symbol.h"
 #include "../kiwi/term.h"
 #include "../kiwi/variable.h"
 #include "../kiwi/constraint.h"
 #include "../kiwi/expression.h"
 #include "../kiwi/strength.h"
 #include "../kiwi/symbolics.h"
 #include "../kiwi/solver.h"
 %}
 
 %include "std_string.i"
 %include "std_vector.i"
 %include "enums.swg"

 %rename(__dec__) operator-=;
 %rename(__inc__) operator+=;
 %rename(__multby__) operator*=;
 %rename(__divby__) operator/=;
 
 %rename(__plus__) operator+;
 %rename(__minus__) operator-;
 %rename(__mult__) operator*;
 %rename(__div__) operator/;
 
 %rename(__eq__) operator==;
 %rename(__leq__) operator<=;
 %rename(__geq__) operator>=;
 

 /* Parse the header file to gpenerate wrappers */
 %include "../kiwi/variable.h"
 %include "../kiwi/strength.h"


 /* Manually declare class Term to avoid std::pair */ 
 class kiwi::Term
 {
 public:
 	Term( const Variable& variable, double coefficient = 1.0 ); 
 	~Term();
 
 	const Variable& variable() const;
 	double coefficient() const;
 	double value() const;
 };
 
 %include "../kiwi/expression.h"

 /* Manually decleare class Constraint to be able to declare native C# enums */
 namespace kiwi { 
 	enum RelationalOperator { OP_LE, OP_GE, OP_EQ };
 };
 class kiwi::Constraint
 {
 public:
	Constraint();
	Constraint( const Expression& expr, RelationalOperator op, double strength = strength::required );
	Constraint( const Constraint& other, double strength );

	~Constraint(); 

	const Expression& expression() const;
	RelationalOperator op() const;
	double strength() const;
 };

 namespace kiwi {
	enum ExceptionCode
	{
		None,   
		DuplicateConstraint,
		UnsatisfiableConstraint,
		UnknownConstraint,
		DuplicateEditVariable,
		BadRequiredStrength,
		UnknownEditVariable,
		InternalSolverErrorObjectiveUnbounded,
		InternalSolverErrorDualOptimizedFailed,
		InternalSolverErrorFailedToFindLeavingRow,
	};
 }

 class kiwi::Solver
 {
 public:
	Solver(); 
	~Solver();

	ExceptionCode addConstraint( const Constraint& constraint );
	ExceptionCode removeConstraint( const Constraint& constraint );
	
	bool hasConstraint( const Constraint& constraint ) const;
	ExceptionCode addEditVariable( const Variable& variable, double strength );

	ExceptionCode removeEditVariable( const Variable& variable );
	bool hasEditVariable( const Variable& variable ) const;

	ExceptionCode suggestValue( const Variable& variable, double value );
	
	void updateVariables();
	void reset();
 };
 
 %template(TermVector) std::vector<kiwi::Term>;
 %include "../kiwi/symbolics.h"
