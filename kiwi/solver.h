/*-----------------------------------------------------------------------------
| Copyright (c) 2013, Nucleic Development Team.
|
| Distributed under the terms of the Modified BSD License.
|
| The full license is in the file COPYING.txt, distributed with this software.
|----------------------------------------------------------------------------*/
#pragma once
#include "constraint.h"

#ifdef DEBUG
#include "debug.h"
#endif

#include "solverimpl.h"
#include "strength.h"
#include "variable.h"


namespace kiwi
{

class Solver
{

public:

	Solver() {}

	~Solver() {}

	/* Add a constraint to the solver.

	Throws
	------
	DuplicateConstraint
		The given constraint has already been added to the solver.

	UnsatisfiableConstraint
		The given constraint is required and cannot be satisfied.

	*/
	ExceptionCode addConstraint( const Constraint& constraint )
	{
		return m_impl.addConstraint( constraint );
	}

	/* Remove a constraint from the solver.

	Throws
	------
	UnknownConstraint
		The given constraint has not been added to the solver.

	*/
	ExceptionCode removeConstraint( const Constraint& constraint )
	{
		return m_impl.removeConstraint( constraint );
	}

	/* Test whether a constraint has been added to the solver.

	*/
	bool hasConstraint( const Constraint& constraint ) const
	{
		return m_impl.hasConstraint( constraint );
	}

	/* Add an edit variable to the solver.

	This method should be called before the `suggestValue` method is
	used to supply a suggested value for the given edit variable.

	Throws
	------
	DuplicateEditVariable
		The given edit variable has already been added to the solver.

	BadRequiredStrength
		The given strength is >= required.

	*/
	ExceptionCode addEditVariable( const Variable& variable, double strength )
	{
		return m_impl.addEditVariable( variable, strength );
	}

	/* Remove an edit variable from the solver.

	Throws
	------
	UnknownEditVariable
		The given edit variable has not been added to the solver.

	*/
	ExceptionCode removeEditVariable( const Variable& variable )
	{
		return m_impl.removeEditVariable( variable );
	}

	/* Test whether an edit variable has been added to the solver.

	*/
	bool hasEditVariable( const Variable& variable ) const
	{
		return m_impl.hasEditVariable( variable );
	}

	/* Suggest a value for the given edit variable.

	This method should be used after an edit variable as been added to
	the solver in order to suggest the value for that variable. After
	all suggestions have been made, the `solve` method can be used to
	update the values of all variables.

	Throws
	------
	UnknownEditVariable
		The given edit variable has not been added to the solver.

	*/
	ExceptionCode suggestValue( const Variable& variable, double value )
	{
		return m_impl.suggestValue( variable, value );
	}

	/* Update the values of the external solver variables.

	*/
	void updateVariables()
	{
		m_impl.updateVariables();
	}

	/* Reset the solver to the empty starting condition.

	This method resets the internal solver state to the empty starting
	condition, as if no constraints or edit variables have been added.
	This can be faster than deleting the solver and creating a new one
	when the entire system must change, since it can avoid unecessary
	heap (de)allocations.

	*/
	void reset()
	{
		m_impl.reset();
	}

	/* Dump a representation of the solver internals to stdout.

	*/
#ifdef DEBUG
	void dump()
	{
		debug::dump( m_impl );
	}
#endif
private:

	Solver( const Solver& );

	Solver& operator=( const Solver& );

	impl::SolverImpl m_impl;
};

} // namespace kiwi
