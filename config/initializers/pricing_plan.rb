class PricingPLanInitializer
if PricingPlan.table_exists?
	$pricing_plans = PricingPlan.define_pricing_plans
end
end