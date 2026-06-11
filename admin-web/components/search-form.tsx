import { Search } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";

export function SearchForm({
  defaultValue,
  placeholder,
  extraParams = {},
}: {
  defaultValue: string;
  placeholder: string;
  extraParams?: Record<string, string>;
}) {
  return (
    <form className="flex items-center gap-2">
      {Object.entries(extraParams).map(([name, value]) =>
        value ? (
          <input key={name} type="hidden" name={name} value={value} />
        ) : null,
      )}
      <div className="relative">
        <Search className="absolute left-2.5 top-1/2 size-4 -translate-y-1/2 text-muted-foreground" />
        <Input
          name="q"
          defaultValue={defaultValue}
          placeholder={placeholder}
          className="w-64 pl-8"
        />
      </div>
      <Button type="submit" variant="secondary">
        Search
      </Button>
    </form>
  );
}
