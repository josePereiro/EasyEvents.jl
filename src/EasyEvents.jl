# TODO: 
# Update the interface to :new, :modified, :same instaead that a binary only outcome
# 

module EasyEvents

include("AbstractEvent.jl")
export AbstractEvent
export old_state, new_state, update!, reset!, trigger, states, istraking
export has_event, has_event!, pull_event, pull_event!, on_event, on_event!, event_type!

include("CustomEvent.jl")
export CustomEvent
export extras

include("FileMTimeEvent.jl")
export FileMTimeEvent

include("FileSizeEvent.jl")
export FileSizeEvent

include("FileContentEvent.jl")
export FileContentEvent

include("PropertyChangedEvent.jl")
export PropertyChangedEvent

end
